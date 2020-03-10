function __init__()
    global AWSpricing_path=joinpath(dirname(dirname(pathof(AWSpricing))),"downloads")
    println("AWS downloads in $AWSpricing_path")
    isdir(AWSpricing_path) || mkdir(AWSpricing_path)

    # get offer file
    offer_idx="$(offer_url)/offers/v1.0/aws/index.json"
    offer_path=joinpath(AWSpricing_path,offer_file)
    if isfile(offer_path)
        println("AWS offers index ready")
    else
        println("Downloading AWS offers index ...")
        download(offer_idx,offer_path)
        println("... done")
    end
    try
        dummy=haskey(AWSidx,"publicationDate")
    catch
        println("Parsing AWS offers ...")
        global AWSidx=JSON.Parser.parsefile(offer_path)
        println("... done")
    end

    # get EC2 offers
    ec2_idx=AWSidx["offers"]["AmazonEC2"]["currentVersionUrl"]
    ec2_url=offer_url*AWSidx["offers"]["AmazonEC2"]["currentVersionUrl"]
    ec2_path=joinpath(AWSpricing_path,ec2_file)
    if isfile(ec2_path)
        println("EC2 pricing index ready")
    else
        println("Downloading EC2 pricing index  ...")
        download(ec2_url,ec2_path)
        println("... done")
    end
    try
        dummy=haskey(EC2idx,"publicationDate")
    catch 
        println("Parsing EC2 pricing index ...")
        global EC2idx=JSON.Parser.parsefile(ec2_path)
        println("... done")
    end

    println("!!! Remember to run AWSpricing.refresh_files() every few weeks to refresh the downloads.")

end

function refresh_files()
    # get offer file
    offer_idx="$(offer_url)/offers/v1.0/aws/index.json"
    offer_path=joinpath(AWSpricing_path,offer_file)
    println("Downloading AWS offers index ...")
    isfile(offer_path) && rm(offer_path)
    download(offer_idx,offer_path)
    println("... done")
    println("Parsing AWS offers ...")
    global AWSidx=JSON.Parser.parsefile(offer_path)
    println("... done")

    # get EC2 offers
    ec2_idx=AWSidx["offers"]["AmazonEC2"]["currentVersionUrl"]
    ec2_url=offer_url*AWSidx["offers"]["AmazonEC2"]["currentVersionUrl"]
    ec2_path=joinpath(AWSpricing_path,ec2_file)
    println("Downloading EC2 pricing index  ...")
    isfile(ec2_path) && rm(ec2_path)
    download(ec2_url,ec2_path)
    println("... done")
    println("Parsing EC2 pricing index ...")
    global EC2idx=JSON.Parser.parsefile(ec2_path)
    println("... done")
end
