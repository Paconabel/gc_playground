This is a playground with some basic experiments related to the Ruby Garbage Collector.

## Requirements

To run it you need to have Ruby installed in your system and the logger gem (ostruct and csv libraries come pre-packaged with Ruby)

## Code examples

There are some examples to realize about different behaviours:

#### How count_objects from ObjectSpace works:

To run it:  `ruby gc-0-count-objects.rb`

It creates 500 objects and collect them in an array. Each time it prints: `Total: 24865 Free: 775 Object: 878`

Where you can see:

  - Total: Sum  of all the live objects and free slots
  - Free: object slots which is not used now
  - Object: current live objects (created as object, excluding arrays, hash, string, class...)

It can give you and idea about how many objects have been created and the free slots remaining.
Also, you can coment the line 10, avoiding collect the objects in the array. So the object count in the last line will be reduced from 892 to 381 (approx.), because all the objects created in the previous iterations were garbage.

#### To create a variable to give some metantic to a method is not a problem to our performance:

To run it: `ruby gc-1-profile_report.rb`

It creates 10000000 objects and collect them into an array.

For this experiment we use the `GC::Profiler.report` that provides us more accurate information.

If we don't collect them into an array, Ruby creates and removes the objects as it needs the "space". If we collect them into an array, Ruby can't claim that "space".

When we collect the objects into the array, it takes more time to execute. Also, there are more objects remaining and less garbage collections.


#### To create a variable to give some metantic to a method is not a problem to our performance:

To run it: `ruby gc-2-profile_being_semantic.rb`

It creates 10000 objects and collect them into an array.

You can comment line 14 and uncomment lines 15,16 so we will create a variable to give more semantic to our method (it's a basic example, but for the purpose of the experiment it fits).

The result is the same in both cases.


#### How to memorize some data in a constant instead of in a variable affect our performance:

To run it: `ruby gc-3-profile_constant.rb`

It runs 500000 times a transaction object creation collected in an array. In the object creation we can use a variable or a constant to set the account of the transaction object.

To change it, in the line 9, we can replace `account` by `ACCOUNT`. When we use a variable, there are more garbage collections and more Ruby objects.

We can also `freeze` the String variables to reduce the object allocation. We can change account in line 9 between `account`, `constant_account`, `frozen_account` and compare results.

#### Call to a static method that instances the class and executes a method does not make difference with calling directly to the method with the class instance:

To run it: `ruby gc-4-profile_instance.rb`

It runs 500000 times a transaction object creation collected in an array. In the object creation we can call a static method that instances the class and creates the transaction or we can call directly the instance method `create`. (we can comment or uncomment lines 26,27 to switch between them)

Regardless of any of the two executions, there are the same garbage collections and Ruby objects.

We can also call to a static method without creating `ClassTransaction` instances, but results are roughly the same.

#### Logging before and after the execution of a method affect our performance:

To run it: `ruby gc-5-profile_logs.rb`

It creates 10000 objects and collect them into an array.

There is a log before and  after the creation.  If we remove one of the logs, there are less garbage collections and less Ruby objects and the time of exectution decreases.

#### Parsing a file to collecting objects to after that process them against directly processing them in the parsing has a peformance difference depending on the number of rows in the file:

To run it: `ruby gc-6-profile_collect_and_iterate.rb`

It parses a csv file from the fixture folder. There are three example files: one with 75 rows, other with 500 rows and the largest one with 2000 rows. We can change them adding on line 6 the name of the csv file.

We can switch (line 54) between the `store_movies_with_map` method and the `store_movies_with_each` method in our code to see the difference between:
- Store our movies in a variable, create an object for each row, collect and store them
- Read them on-the-fly, create an object for each row and directly store them one by one.~

You can change `MOVIES_FILE_PATH` to select different fixtures:
- For the 75 row file there is no difference
- For the 500 row file more objects remain created and more memory is taken when the process is finished for the `store_movies_with_map` method
- For the 2000 rows file more objects remain created and more memory is taken when the process is finished for the `store_movies_with_map` method

#### Creating objects and where are stored

To run it: `ruby gc-7-heap-vs-stack.rb`

It creates an array and store different types of objects, you can see `Integer` and tiny `String` are stored in stack if possible, whether the rest is allocated in the heap. You can change line 13 to check where these `String` are allocated to.

We can use `GC.stat` to inspect the heap.

#### Debug object allocation in heap

To run it: `ruby gc-8-object-allocation-heap.rb`

It creates some types of objects and goes through the heap to find them and print information about:
- Memory size
- Source file and line where object was allocated
- GC generation phase
- Class name
- method used to create the object

Also it dumps all the information in a JSON file. This is useful to debug with other tools like [MemoryDiagnostics](https://github.com/discourse/discourse/blob/586cca352d1bb2bb044442d79a6520c9b37ed1ae/lib/memory_diagnostics.rb) or [heapy](https://github.com/schneems/heapy).

#### Debug object allocation in heap ( part 2 )

To run it: `ruby gc-9-object-allocation-heap.rb`

It creates some types of objects and goes through the heap to find them and print information about the object instances, very similar to `ObjectSpace.count_objects`

You can also try [gc_tracer](https://github.com/ko1/gc_tracer)

#### Destroying the objects in heap

To run it: `ruby gc-10-object-finalizers.rb`

It used `define_finalizer` to define a `proc` that should be called when the object is garbage collected.

Usually this is only need to free up native resources in gems using C extensions, be aware when defining the `proc` to avoid [memory leaks](https://www.mikeperham.com/2010/02/24/the-trouble-with-ruby-finalizers/)

#### Allocating memory

To run it: `ruby gc-11-allocating.rb`

It shows a different way to create objects without initializing them, mostly used in gems with C extensions to decorate C structs as a Ruby object.

## GC information

We are using:

#### ObjectSpace

We use the `count_objects` that displays the following info:
```
{
  :TOTAL=>24867,
  :FREE=>8602,
  :T_OBJECT=>881,
  :T_CLASS=>640,
  :T_MODULE=>42,
  :T_FLOAT=>4,
  :T_STRING=>8424,
  :T_REGEXP=>137,
  :T_ARRAY=>985,
  :T_HASH=>85,
  :T_STRUCT=>12,
  :T_BIGNUM=>2,
  :T_FILE=>3,
  :T_DATA=>205,
  :T_COMPLEX=>1,
  :T_SYMBOL=>29,
  :T_IMEMO=>4769,
  :T_ICLASS=>46
}
```

The keys starting with :T_ means live objects. For example, :T_ARRAY is the number of arrays.
:FREE means object slots which is not used now.
:TOTAL means sum of above.

#### GC::Profiler

We use the `report` that displays the following info:

|Index | Invoke Time(sec) | Use Size(byte) | Total Size(byte) | Total Object | GC Time(ms)|
|---|---|---|---|---|---|
|1 | 0.092 | 728040 | 995520 | 24888 | 1.22200000000001463007|

 - **`Index`** column is a counter of each garbage collection
 - **`Invoke time`** shows when the garbage collection occurred, measured as seconds after the Ruby script started to run
 - **`Use size`** shows how much leap memory is used by all live Ruby objects after each collection is finished
 - **`Total size`** shows the memory taken by live objects plus the size of the free list (the total size of the heap after collection)
 - **`Total object`** shows the total number of Ruby objects (live or on the free list).
 - **`GC time`** shows the amount of time each collection took

#### GC.stat

We can see in the stats the following numbers:
```
{
  :count=>12,
  :heap_allocated_pages=>61,
  :heap_sorted_length=>61,
  :heap_allocatable_pages=>0,
  :heap_available_slots=>24864,
  :heap_live_slots=>24254,
  :heap_free_slots=>610,
  :heap_final_slots=>0,
  :heap_marked_slots=>14945,
  :heap_eden_pages=>61,
  :heap_tomb_pages=>0,
  :total_allocated_pages=>61,
  :total_freed_pages=>0,
  :total_allocated_objects=>71807,
  :total_freed_objects=>47553,
  :malloc_increase_bytes=>884816,
  :malloc_increase_bytes_limit=>16777216,
  :minor_gc_count=>9,
  :major_gc_count=>3,
  :remembered_wb_unprotected_objects=>211,
  :remembered_wb_unprotected_objects_limit=>420,
  :old_objects=>14437,
  :old_objects_limit=>28880,
  :oldmalloc_increase_bytes=>921328,
  :oldmalloc_increase_bytes_limit=>16777216
}
```

- **`minor_gc_count`** is the counts, since the start of the Ruby process, of Minor GC (garbage collect objects which are “new" : endure to 3 or less garbage collection cycles)
- **`major_gc_count`** is the counts, since the start of the Ruby process, of Major GC (garbage collect all objects)
- **`count`** equals minor_gc_count + major_gc_count.
- **`heap_allocated_pages`** is the number of currently allocated heap pages.
- **`heap_sorted_length`** is the actual size of the heap in memory.
- **`heap_allocatable_pages`**, these are heap-page-sized chunks of memory that Ruby owns and where we could allocate a new heap page in.
- **`heap_available_slots`** is the total number of slots in heap pages
- **`heap_live_slots`** is the number of live objects
- **`heap_free_slots`** are slots in heap pages which are empty.
- **`heap_final_slots`** are object slots which have finalizers attached to them.
- **`heap_marked_slots`** is the count of old objects plus write barrier unprotected objects.
- **`heap_eden_pages`** are heap pages which contain at least one live object in them (eden pages can never be freed)
- **`heap_tomb_pages`** contain no live objects.

- **`total_allocated_pages`**, **`total_freed_pages`**, **`total_allocated_objects`**, **`total_freed_objects`** are cumulative allocated/freed numbers.
These numbers are cumulative for the life of the process. They are never reset and will not go down.

- **`malloc_increase_bytes`** refers to when Ruby allocates space for objects outside of the “heap”.
- **`oldmalloc_increase_bytes`** refers to when Ruby allocates space for old objects outside of the “heap”.
- **`remembered_wb_unprotected_objects`** is a count of objects which are not protected by the write-barrier and are part of the remembered set.
- **`old_objects`** is the count of object slots marked as old.

- **`oldmalloc_increase_bytes_limit`** and **`old_objects_limit`** are garbage collection thresholds

(_This GC.stat information has been sumarized from the post:_ https://www.speedshop.co/2017/03/09/a-guide-to-gc-stat.html)


#### Annex

##### Blog posts

[The trouble with finalizers](https://www.mikeperham.com/2010/02/24/the-trouble-with-ruby-finalizers/)
[A guide to GC.stat](https://www.speedshop.co/2017/03/09/a-guide-to-gc-stat.html)

##### Tools

[memory_profiler](https://github.com/SamSaffron/memory_profiler)
[derailed_benchmarks](https://github.com/schneems/derailed_benchmarks)
[gc_tracer](https://github.com/ko1/gc_tracer)
[heapy](https://github.com/schneems/heapy)
[MemoryDiagnostics](https://github.com/discourse/discourse/blob/586cca352d1bb2bb044442d79a6520c9b37ed1ae/lib/memory_diagnostics.rb)
