#!/usr/bin/env python3
import re
import sys
import math
import time
import random
import operator
import fileinput
from functools import partial, reduce, wraps

def debug(*args):
    if False:
        print(*args)

def add(*args):
    return sum(args)

def subtract(*args):
    if len(args) == 1:
        return -args[0]
    return reduce(operator.sub, args)

def multiply(*args):
    return reduce(operator.mul, args)

def divide(*args):
    return reduce(operator.truediv, args) 

def floordivide(*args):
    return reduce(operator.floordiv, args) 

def quote(expression):
    if not isinstance(expression, list):
        return str(expression)
    return "(" + " ".join(map(quote, expression)) + ")"

def runtime():
    return time.time() - runtime.start
runtime.start = time.time()

def newline():
    print()

def display(*args, **kwargs):
    print(*args, **kwargs)

def listfn(fn):
    @wraps(fn)
    def result(*args, **kwargs):
        return list(fn(*args, **kwargs))
    return result

class Lambda(object):
    def __init__(self, params, body, context):
        self.params = params
        self.body = body
        self.context = context

    def __call__(self, *args):
        context = self.context.copy()
        context.update(zip(self.params, args))
        return evaluate(self.body, context)

    def __str__(self):
        return "(lambda {}) {}".format(" ".join(self.params), quote(self.body))

class Symbol(str): pass

builtins = {
    '+': add,
    '-': subtract,
    '*': multiply,
    '/': divide,
    '//': floordivide,
    '%': operator.mod,
    '<': operator.lt,
    '<=': operator.le,
    '>': operator.gt,
    '>=': operator.ge,
    '=': operator.eq,
    '!=': operator.ne,
    'not': operator.not_,
    'remainder': operator.mod,
    'abs': abs,
    'inc': lambda x: x + 1,
    'dec': lambda x: x - 1,
    'quote': quote,
    'map': listfn(map),
    'filter': listfn(filter),
    'reduce': listfn(reduce),
    'range': listfn(range),
    'zip': listfn(zip),
    'help': help,
    'odd?': lambda x: x % 2 == 1,
    'even?': lambda x: x % 2 == 0,
    'random': random.randrange,
    'true': True,
    'false': False,
    'runtime': runtime,
    'newline': newline,
    'display': display,
    'id': lambda x: x,
}
builtins.update(fn for fn in vars(math).items() if not fn[0].startswith('_'))

def tokenize(program):
    program = program.strip()
    program = program.replace('(', '( ')
    program = program.replace(')', ' )')
    token = ""
    string = None
    for char in program:
        if char == '"':
            if string is not None:
                yield string
                string = None
            else:
                string = ""
        elif string is not None:
            string += char
        elif re.match('\s', char):
            if re.match('^-?\d+', token):
                yield eval(token)
            elif token:
                yield Symbol(token)
            token = ""
        else:
            token += char

def parse(tokens):
    result = []
    stack = [result]
    for token in tokens:
        if token == '(':
            subexpr = []
            stack[-1].append(subexpr)
            stack.append(subexpr)
        elif token == ')':
            stack.pop()
        else:
            stack[-1].append(token)
    return result

def evaluate(expression, context):
    if isinstance(expression, Symbol):
        return context[expression]
    elif not isinstance(expression, list):
        return expression

    head, *tail = expression
    debug("ht", head, tail)
    if head == "define":
        if isinstance(tail[0], list):
            (name, *params), *body = tail
            context[name] = Lambda(params, body, context)
        else:
            name, value = tail
            value = evaluate(value, context)
            context[name] = value
        return context[name]
    elif head == "cond":
        for clause in tail:
            predicate, expression = clause
            if predicate == "else" or evaluate(predicate, context):
                return evaluate(expression, context)
    elif head == "if":
        if len(tail) == 3:
            predicate, consequent, alternative = tail
        else:
            predicate, consequent = tail
            alternative = False
        if evaluate(predicate, context):
            return evaluate(consequent, context)
        else:
            return evaluate(alternative, context)
    elif head == "and":
        for expression in tail:
            result = evaluate(expression, context)
            if not result:
                break
        return result
    elif head == "or":
        for expression in tail:
            result = evaluate(expression, context)
            if result:
                break
        return result
    elif isinstance(head, list):
        for subexpr in expression:
            result = evaluate(subexpr, context)
        return result
    else:
        function = evaluate(head, context)
        args = [evaluate(arg, context) for arg in tail]
        debug("fn", function, args)
        return function(*args)

def main():
    context = builtins
    if len(sys.argv) == 1:
        while True:
            try:
                line = input(">>> ")
            except EOFError:
                return

            try:
                expression = parse(tokenize(line))
                result = evaluate(expression, context)
                print(result)
            except Exception as e:
                print(e.__class__.__name__ + ":", str(e))
    else:
        program = ""
        for line in fileinput.input():
            program += line
        expression = parse(tokenize(program))
        evaluate(expression, context)

if __name__ == "__main__": main()
