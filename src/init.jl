function __init__()
    global AWSpricing_path=joinpath(dirname(dirname(pathof(AWSpricing))),"downloads")
    println("AWS downloads in $AWSpricing_path")
    isdir(AWSpricing_path) || mkdir(AWSpricing_path)

    # get offer file
    offer_idx="$(offer_url)/offers/v1.0/aws/index.json"
    if isfile(offer_file)
        println("AWS offers index ready")
    else
        println("Downloading AWS offers index ...")
        download(offer_idx,offer_file)
        println("... done")
    end
    try
        dummy=haskey(AWSidx,"publicationDate")
    catch
        println("Parsing AWS offers ...")
        global AWSidx=JSON.Parser.parsefile(offer_file)
        println("... done")
    end

    # get EC2 offers
    ec2_idx=AWSidx["offers"]["AmazonEC2"]["currentVersionUrl"]
    ec2_url=offer_url*AWSidx["offers"]["AmazonEC2"]["currentVersionUrl"]
    if isfile(ec2_file)
        println("EC2 pricing index ready")
    else
        println("Downloading EC2 pricing index  ...")
        download(ec2_url,ec2_file)
        println("... done")
    end
    try
        dummy=haskey(EC2idx,"publicationDate")
    catch 
        println("Parsing EC2 pricing index ...")
        global EC2idx=JSON.Parser.parsefile(ec2_file)
        println("... done")
    end

end

