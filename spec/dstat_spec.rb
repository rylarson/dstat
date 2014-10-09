require 'rspec'
require 'dstat'

describe Dstat do
	include Dstat
	it "creates multiple indexes for dstat output" do
		dstat = import_dstat_csv('spec/dstat-test.csv')
		
		expect(dstat[:epoch]).to eq(dstat["epoch"])
		
		[:usr, :sys, :idl, :wai, :hiq, :siq].each do |usage|
			expect(dstat[:total_cpu_usage][usage]).to eq(dstat["total_cpu_usage"][usage.to_s])
		end

		[:read, :writ].each do |dsk|
			expect(dstat[:"dsk/total"][dsk]).to eq(dstat["dsk/total"][dsk.to_s])
		end

		[:"1m", :"5m", :"15m"].each do |avg|
			expect(dstat[:load_avg][avg]).to eq(dstat["load_avg"][avg.to_s])
		end

		[:used, :buff, :cach, :free].each do |usage|
			expect(dstat[:memory_usage][usage]).to eq(dstat["memory_usage"][usage.to_s])
		end

		[:recv,	:send].each do |net|
			expect(dstat[:"net/total"][net]).to eq(dstat["net/total"][net.to_s])
		end

		# TODO, write the rest of the assertions
	end

	it "correctly parses the data" do
		# TODO write parser validation
	end
end
