# AWSpricing

Dirty simple AWS pricing helper

## INSTALLATION

### Using SLIM Registry (preferred method) ###

First switch to package manager prompt (using ']') and add SLIM registry:

```
	registry add https://github.com/slimgroup/SLIMregistryJL.git
```

Then still from package manager prompt add AWSpricing:

```
	add AWSpricing
```

### Adding without SLIM registry ###

After switching to package manager prompt (using ']') type:

```
	add https://github.com/slimgroup/AWSpricing.jl.git
```

### Notes

The first time you use the module, it has to download index files from AWS. Those are large so it takes a while.

Every time you use module it has to load index files into memeory, and it also takes a while.

In either case, the screen output will show you what is going on.

### Examples

List the EC2 instances with memeory range from 4 to 8 GiB

    	AWS_EC2_SearchByMemory(4,8)

Same but with *EBS only* storage

    	AWS_EC2_SearchByMemory(4,8,true)

Use the *Product Key* to get full raw instance record

    	AWS_EC2_ProductByKey("GK9M85NVHXSYVZD6")

where *Product Key* is listed by AWS_EC2_SearchByMemory.

