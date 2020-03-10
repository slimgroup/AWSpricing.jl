export AWS_EC2_SearchByMemory
function AWS_EC2_SearchByMemory(mmin::Number,mmax::Number)
    global EC2products=EC2idx["products"]
    EC2keys=keys(EC2products)
    header=["ECU" "MEM" "VCPU" "Type" "Product Key" "Instance SKU" "Instance Family" "Usage"]

    EC2out=Array{Any,1}(undef,0)
    cnt=0
    for k in EC2keys
        haskey(EC2products[k]["attributes"],"memory") || continue
        haskey(EC2products[k]["attributes"],"instancesku") || continue
        EC2products[k]["attributes"]["memory"]=="NA" && continue
        EC2products[k]["attributes"]["ecu"]=="NA" && continue
        EC2products[k]["attributes"]["location"]=="US East (N. Virginia)" || continue
        EC2products[k]["attributes"]["operatingSystem"]=="Linux" || continue
        EC2products[k]["attributes"]["tenancy"]=="Dedicated" || continue
        EC2products[k]["attributes"]["preInstalledSw"]=="NA" || continue
        #EC2products[k]["attributes"]["storage"]=="EBS only" || continue
        #EC2products[k]["attributes"]["usagetype"][1:14]=="DedicatedUsage" && continue # ??
        try
            instancesku=EC2products[k]["attributes"]["instancesku"]
            instanceType=EC2products[k]["attributes"]["instanceType"]
            instanceFamily=EC2products[k]["attributes"]["instanceFamily"]
            usagetype=EC2products[k]["attributes"]["usagetype"]
            memstrs=split(EC2products[k]["attributes"]["memory"])
            memory=parse(Float64,memstrs[1])
            ecu=try
                parse(Float64,EC2products[k]["attributes"]["ecu"])
            catch
                -1.
            end
            vcpu=parse(Int,EC2products[k]["attributes"]["vcpu"])
            if memory>=mmin && memory<=mmax
                elm=(ecu,memory,vcpu,instanceType,k,instancesku,instanceFamily,usagetype)
                #println(elm)
                append!(EC2out,[elm...])
                cnt+=1
            end
        catch
            display(EC2products[k]["attributes"])
        end
    end
    EC2out=permutedims(reshape(EC2out,8,cnt))
    EC2sort=sortperm(EC2out[:,1])
    @printf("%7s %7s %4s %12s %17s %17s %18s %s\n",header...)
    for i in EC2sort
        @printf("%7.2f %7.2f %4d %12s %17s %17s %18s %s\n",EC2out[i,:]...)
    end
end

export AWS_EC2_ProductByKey
function AWS_EC2_ProductByKey(k::String)
    try
        display(EC2products[k])
        display(EC2products[k]["attributes"])
    catch
        println("Error: invalid key $k")
    end
end

