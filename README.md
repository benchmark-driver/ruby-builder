# ruby-builder

Build ruby binaries per revision under rbenv directory

## Installation

Install it yourself as:

```bash
$ gem install ruby-builder
```

## Usage
### Single revision build

```
$ rbenv versions
  system
* 2.5.0 (set by /home/k0kubun/.rbenv/version)
$ ruby-builder revision r62436 -d ~/src/github.com/ruby/ruby
I, [2018-02-17T15:00:17.674440 #8189]  INFO -- : Parsing revisions at '/home/k0kubun/src/github.com/ruby/ruby'...
I, [2018-02-17T15:00:17.677752 #8189]  INFO -- : Starting to build r62436 (1 revisions) from '/home/k0kubun/src/github.com/ruby/ruby'
I, [2018-02-17T15:00:17.683382 #8189]  INFO -- : + git checkout d8d19683b62cc8e9254e651acd89a6cdfa3a0f54
...(snip)...
I, [2018-02-17T15:00:17.716479 #8189]  INFO -- : + /home/k0kubun/src/github.com/ruby/ruby/configure --disable-install-doc --prefix\=/home/k0kubun/.rbenv/versions/r62436
...(snip)...
I, [2018-02-17T15:00:41.168594 #8189]  INFO -- : + make -j8
...(snip)...
I, [2018-02-17T15:01:33.717682 #8189]  INFO -- : + make install
...(snip)...
I, [2018-02-17T15:05:39.939284 #23243]  INFO -- : Succeeded to install r62436 (1/1) to '/home/k0kubun/.rbenv/versions/r62436'
I, [2018-02-17T15:05:39.939364 #23243]  INFO -- : + git -C /home/k0kubun/src/github.com/ruby/ruby checkout trunk
Previous HEAD position was d8d19683b6... fix regexp literal warning.
Switched to branch 'trunk'
$ rbenv versions
  system
* 2.5.0 (set by /home/k0kubun/.rbenv/version)
  r62436
$ rbenv shell r62436
$ ruby -v
ruby 2.6.0dev (2018-02-16 trunk 62436) [x86_64-linux]
```

### Multiple revisions build

```
$ rbenv versions
  system
* 2.5.0 (set by /home/k0kubun/.rbenv/version)
  r62436
$ ruby-builder revision r62436..r62445 -d ~/src/github.com/ruby/ruby
I, [2018-02-17T15:09:12.852817 #5338]  INFO -- : Parsing revisions at '/home/k0kubun/src/github.com/ruby/ruby'...
I, [2018-02-17T15:09:14.889281 #5338]  INFO -- : Starting to build r62436..r62445 (3 revisions) from '/home/k0kubun/src/github.com/ruby/ruby'
I, [2018-02-17T15:09:14.894662 #5338]  INFO -- : Skipped to install r62436 (1/3): already installed
I, [2018-02-17T15:09:14.894731 #5338]  INFO -- : + git checkout 21249d849bb70217e0780b12d5f398826bd3b8d3
...(snip)...
I, [2018-02-17T15:09:14.928467 #5338]  INFO -- : + /home/k0kubun/src/github.com/ruby/ruby/configure --disable-install-doc --prefix\=/home/k0kubun/.rbenv/versions/r62437
...(snip)...
I, [2018-02-17T15:09:34.250019 #5338]  INFO -- : + make -j8
...(snip)...
I, [2018-02-17T15:10:19.496940 #5338]  INFO -- : + make install
...(snip)...
I, [2018-02-17T15:10:22.204407 #5338]  INFO -- : Succeeded to install r62437 (2/3) to '/home/k0kubun/.rbenv/versions/r62437'
I, [2018-02-17T15:10:22.204513 #5338]  INFO -- : + git checkout def3714be2436413c85811005e3166ccf5633554
...(snip)...
I, [2018-02-17T15:10:22.236696 #5338]  INFO -- : + /home/k0kubun/src/github.com/ruby/ruby/configure --disable-install-doc --prefix\=/home/k0kubun/.rbenv/versions/r62445
...(snip)...
I, [2018-02-17T15:10:42.356260 #5338]  INFO -- : + make -j8
...(snip)...
I, [2018-02-17T15:11:03.875723 #5338]  INFO -- : + make install
...(snip)...
I, [2018-02-17T15:11:05.625496 #5338]  INFO -- : Succeeded to install r62445 (3/3) to '/home/k0kubun/.rbenv/versions/r62445'
I, [2018-02-17T15:11:05.625576 #5338]  INFO -- : + git -C /home/k0kubun/src/github.com/ruby/ruby checkout trunk
Switched to branch 'trunk'
$ rbenv versions
  system
* 2.5.0 (set by /home/k0kubun/.rbenv/version)
  r62436
  r62437
  r62445
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
