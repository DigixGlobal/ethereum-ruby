$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'ethereum'
require 'pry'

ENV['ETH_HTTP_PORT'] ||= '8545'
ENV['ETH_IPC_PATH'] ||= "#{ENV['HOME']}/EtherDev/data/geth.ipc"
