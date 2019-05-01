# Universal Frameworks
Universal frameworks is a tool for creating cross-language systems frameworks using swift as a host language. The general architecture of a universal framework is as follows:

## The Host Framework
A framework author begins by writing the core of their framework in swift using as simple types as possible. This is referred to as a host framework and is intended to have the most minimal API possible. The universal framework framework takes these functions and wraps them in a simplistic server that simply acts as a language agnostic interface for these functions. This is hereafter referred to as the framework server.

## Client Frameworks
For each language you would like the framework to be compatible with, you simply add the language to the list of client frameworks. Functions with an equivalent interface to the host framework's public facing API are automatically generated in the client language. These functions are given an implementation which calls the requested function on the framework server.

Client framework should work out of the box, however the intended purpose of this tool is to make it so you don't have to rewrite logic for you framework in a variety of languages, not so that you don't have to follow good framework dsign in all of the languages you target. Because of this, we highly reccommend that for each client language you choose to target, you write a wrapper around the base client framework. This will allow you to create nicer interfaces for the client framework that are idomatic in the given language.

### A Note on Higher Order Functions

Handling higher order functions is the immediately obvious challenge that makes this system somewhat difficult to acomplish. We chose to handle them like this: If the host framework takes a closure anywhere in its external interface, when it iscalled from the framework server, the universal framework passes it a closure which simply initiates communication back to the client framework. The client framework then executes the equivalent higher order function in its own environment, and communicates the result back to the framework server. At that point, the injected closure in the framework server returns.

## Design Limitations

This does have the limitation that you cannot pass any references around between the host and client framework. Communication between the two is *pass by value only*. We considered this a fine tradeoff as in most cases, this actually encourages good design.