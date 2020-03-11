export AWS_EC2_SearchByMemory
"""
List EC2 instance information in memeory range [mmin,mmax]

    AWS_EC2_SearchByMemory(mmin::Number,mmax::Number,EBSonly::Bool=false)

Notes:

- You can exclude instances that do not have "EBS only" storage by setting EBSonly to true.
- Instances with Variable/NA ECU are printed with NaN in ECU column.

"""
function AWS_EC2_SearchByMemory(mmin::Number,mmax::Number,EBSonly::Bool=false)
    global EC2products=EC2idx["products"]
    global EC2terms=EC2idx["terms"]
    EC2keys=keys(EC2products)
    header=["ECU" "MEM" "VCPU" "Type" "Instance Family" "Price USD" "Product Key" "Storage"]

    EC2out=Array{Any,1}(undef,0)
    cnt=0
    for k in EC2keys
        haskey(EC2products[k]["attributes"],"memory") || continue
        haskey(EC2products[k]["attributes"],"instancesku") || continue
        EC2products[k]["attributes"]["location"]=="US East (N. Virginia)" || continue
        EC2products[k]["attributes"]["currentGeneration"]=="Yes" || continue
        EC2products[k]["attributes"]["operatingSystem"]=="Linux" || continue
        EC2products[k]["attributes"]["preInstalledSw"]=="NA" || continue
        EC2products[k]["attributes"]["tenancy"]=="Dedicated" || continue
        EC2products[k]["attributes"]["memory"]=="NA" && continue
        EC2products[k]["attributes"]["ecu"]=="NA" && continue
        if EBSonly
            EC2products[k]["attributes"]["storage"]=="EBS only" || continue
        end
        EC2products[k]["attributes"]["usagetype"][1:9]=="UnusedDed" || continue # ??
        try
            memstrs=split(EC2products[k]["attributes"]["memory"])
            memory=parse(Float64,memstrs[1])
            ecu=try
                parse(Float64,EC2products[k]["attributes"]["ecu"])
            catch
                NaN
            end
            if memory>=mmin && memory<=mmax
                ecu_mem=@sprintf("%08.2f:%08.2f",ecu,memory)
                #elm=(ecu_mem,ecu,memory,vcpu,instanceType,k,instancesku,instanceFamily,usagetype)
                elm=(ecu_mem,k,ecu,memory)
                append!(EC2out,[elm...])
                cnt+=1
            end
        catch
            display(EC2products[k]["attributes"])
        end
    end
    EC2out=permutedims(reshape(EC2out,4,cnt))
    EC2sort=sortperm(EC2out[:,1])
    @printf("%8s %8s %5s %14s %19s %9s %17s %s\n",header...)
    for i in EC2sort
        (k,ecu,memeory)=(EC2out[i,2:4]...,)
        vcpu=parse(Int,EC2products[k]["attributes"]["vcpu"])
        instanceType=EC2products[k]["attributes"]["instanceType"]
        instanceFamily=EC2products[k]["attributes"]["instanceFamily"]
        price=parse(Float64,search_key(AWSpricing.EC2terms["OnDemand"][k],"USD",0))
        storage=EC2products[k]["attributes"]["storage"]
        #instancesku=EC2products[k]["attributes"]["instancesku"] % %17s
        @printf("%8.2f %8.2f %5d %14s %19s %9.5f %17s %s\n",
            ecu,memeory,vcpu,instanceType,instanceFamily,price,k,storage)
    end
end

function search_key(D::Dict,K::String,l::Int)
    ks=keys(D)
    for k in ks
        #println((l,k,D[k],typeof(D[k])))
        k==K && return D[k]
        if typeof(D[k])<:Dict && length(keys(D[k]))>0
            return search_key(D[k],K,l+1)
        end
    end
    return nothing
end

export AWS_EC2_ProductByKey
"""
Print full raw EC2 product record

    AWS_EC2_ProductByKey(ProductKey::String)

where ProductKey is the one listed by AWS_EC2_SearchByMemory.

"""
function AWS_EC2_ProductByKey(k::String)
    try
        display(EC2products[k])
        display(EC2products[k]["attributes"])
    catch
        println("Error: invalid key $k")
    end
end

