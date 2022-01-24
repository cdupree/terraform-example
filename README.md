Install terraform:

brew tap hashicorp/tap
brew install hashicorp/tap/terraform

You also need to set up your API key info in ~/.aws/credentials.

You can also download via the HashiCorp site.

Terraform works by reading in a list of resources that you provide.  These
resources all have a type that maps to a cloud component to be created, and
a name that can be used to refer to the resource. Each resource has various
configuration items that have to be provided in order to correctly create the
resource. Resources also have attributes can be accessed using the resource
type, and name.  This allows other resources to make use of them.  
Terraform understands the order in which resources must be created in a given 
cloud environment, and a developer only needs to ensure that you create all 
the components that your infrastructure needs in order to work, and that you 
have connected them together as required.  

When searching for resource, terraform reads all files of the form *.tf.
This allows the infrastructure 

provider.tf - sets up terraform, and aws

vpc.tf      - creates the a cloud network container in which we can build
              instances.


Start by running

terraform init 

to download the provider, and set up the terraform environment.

You can run 

terraform plan

in order to view that actions that terraform thinks that it should take.
Initially, nothing exsist, so terraform will expect to create these
resources.  Assuming that the plan is successful, you can then ru

terrafrom apply

to actually create the needed resources. As you develop your architecture
you may wish to apply in stages as you complete the various pieces. If 
a component exists, and is already configured as you ask, then terraform
will simply ignore it. It also ignores other components it may find which
are not specified in your files. It will then create or modify resources
as needed.  The plan subcommand will output information about these changes
so that you can ensure everything is acceptable before you plan.
