module AWSpricing
using JSON
using Printf

global AWSpricing_path
global AWSidx
global EC2idx
global EC2products

# defaults
region="us-east-1"
offer_url="https://pricing.$(region).amazonaws.com"
offer_file="AWSoffers.json"
ec2_file="AmazonEC2.json"

include("init.jl")
include("EC2utils.jl")

end # module
