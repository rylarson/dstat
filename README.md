# dstat

dstat is a ruby gem that provides utilites for working with dstat data

Given a dstat csv file, this will import the data, columnwise, into a Hash.

dstat CSV files are often of the form:

```  
top_level_header_1,top_level_header_2,,,
child_header_1,child_header_2,child_header3,child_header4
```  
   
or a more concrete example:

```  
epoch,memory usage,,,
epoch,used,buff,cach,free
1121245,12456,12856,20059,2999095
1121246,12457,12855,20068,2996885
```

Where `used`, `buff`, `cache`, and `free` all correspond to memory usage. An index is created
for each (parent header -> child header), unless parent header == child header.

Using the concrete example above, the hash returned from this method would be indexed
like so:

```
hash[:epoch] => [1121245, 1121246]
hash[:memory_usage] => {:used => [12456, 12457], 
                        :buff => [12856, 12855], 
                        :cach => [20059, 20068], 
                        :free => [2999095, 2996885]            
                        }
```

Written another way:


```
puts hash[:memory_usage][:used]
=> "[12456, 12457]"
```

The hash also has aliases for the keys, so you can access the values multiple ways:

```
puts hash[:memory_usage][:used]
=> "[12456, 12457]"

puts hash["memory_usage"]["used"]
=> "[12456, 12457]"

puts hash["memory_usage_used"]
=> "[12456, 12457]"
```

## Installation

Add this line to your application's Gemfile:

    gem 'dstat'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dstat

## Usage

Dstat is a module, and you can include it to mix in it's functionality.

```
require 'dstat'
include Dstat
```

Once you do this, you have access to all of the Dstat methods. The most useful of which is:

```
import_dstat_csv(file)
```

You can pass this a File or a String representing a path to a file, and it will return a colmnwise hash of keys to values

## Contributing

1. Fork it ( http://github.com/rylarson/dstat/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
