# Ethereum library for Ruby

[![Join the chat at https://gitter.im/DigixGlobal/ethereum-ruby](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/DigixGlobal/ethereum-ruby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

A simple library for Ethereum.

## Features

* IPC Client with batch calls support
* Compile and deploy Solidity contracts
* Expose deployed contracts as Ruby classes
* Test solidity contracts with a Ruby testing framework of your choice
* Call and wait for the result of Solidity function calls.

## Requirements

We currently support UNIX/Linux environments and Windows IPC support on the roadmap.

You will need to have a properly working Ruby installation.  We recommend [RVM](http://rvm.io/)

To use this library you will need to have a running Ethereum node with IPC support enabled (default).  We currently support [Go-Ethereum client](https://github.com/ethereum/go-ethereum)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ethereum'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ethereum

## Basic Usage

### IPC Client Connection

```ruby
client = Ethereum::IpcClient.new("#{ENV['HOME']}/.ethereum_testnet/geth.ipc")
```

### Solidity contract compilation and deployment

```ruby
init = Ethereum::Initializer.new("#{ENV['PWD']}/spec/fixtures/SimpleNameRegistry.sol", client)
init.build_all
simple_name_registry_instance = SimpleNameRegistry.new
simple_name_registry_instance.deploy_and_wait
```

### Transacting and Calling Solidity Functions

Solidity functions are exposed as transact_<underscore_function_name>(params) (or transact_and_wait_<underscore_function_name>(params))  and call_<underscore_function_name>(params) e.g.:

```ruby
simple_name_registry_instance.transact_and_wait_register("0x5b6cb65d40b0e27fab87a2180abcab22174a2d45", "minter.contract.dgx")
simple_name_registry_instance.transact_register("0x385acafdb80b71ae001f1dbd0d65e62ec2fff055", "anthony@eufemio.dgx")
```

## Roadmap

* Add JSON RPC Client support
* Add Windows IPC Client (named pipes)
* Solidity constant function output should be properly formatted according to the ouput data type
* Unit testing and contract testing examples
* Add more examples
* API documentation

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/DigixGlobal/ethereum-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

