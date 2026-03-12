# Turtle / RDF Interpreter (Part 1)

This project contains the fully functioning Lexer and Parser for our coursework. It successfully reads `.ttl` or `.rql` files, resolves Turtle shorthand, and expands `@prefix` dictionary declarations into canonical N-Triples.

## 🚀 How to Build and Run

Make sure you have [Haskell Stack](https://docs.haskellstack.org/en/stable/README/) installed.

**1. Build the project:**
```bash
stack build