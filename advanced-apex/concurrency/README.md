# Concurrency

The only real way to address concurrency issues is at design time.

From a language perspective:
- Apex is not a multithreaded language.
- No shared data. No ability to create traditional threads.
- Static variables are specific to one thread and one execution context (thread local storage).

However;
- Asynchronous processes do run in separate threads and can be concurrent.
- Those processes can access the database.


## Optimistic Concurrency


