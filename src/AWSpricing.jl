module AWSpricing
using JSON

global AWSpricing_path
global AWSidx
global EC2idx

# defaults
region="us-east-1"
offer_url="https://pricing.$(region).amazonaws.com"
offer_file="AWSoffers.json"
ec2_file="AmazonEC2.json"

include("init.jl")
include("EC2utils.jl")

end # module
