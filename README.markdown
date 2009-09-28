Chambermaid
===========

Chambermaid acts as interpreter between Git repositories and Ruby objects.

The main objective of Chambermaid is not to mess with your classes or objects.
Instead Chambermaid should provide a simple but powerful API.

Chambermaid keeps diaries for identifiable ruby objects and writes pages for
each snapshot. Chambermaid browses theses diaries to find the right page for
your ruby object.

Introduction
------------

coming soon...

TODO
----
* Documentation (partially)
* support for submodules still need observer and hooks
* snapshot creation partially implemented, depends on support for submodules
* speedup for class creation
* reduce numbed of context specific, generated classes
* replace context object stub (currenly ostruct) with instance of real class