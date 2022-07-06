
# Variable file that maps server profile name to physical server assignment
# Setting no physical server assignment will still create the server profiles on Intersight.
# Creating the server profiles upfront (even without assigning a server) will offer better naming and IP consistency for the cluster
# 
# Important: This same tfvars should be used on the "OS install" and should be kept in sync between the 2x Terraform plans.
# This will ensure that OS installations are only triggered if a server is assigned.
# Also:
#    * the profile name will be used as the OS server names. 
#    * the order of the this list will be taken into consideration to assign the IP address to the nodes. 

# REQUIRED: Uncomment the variable below and define profile name to server names mapping

/*
profiles2servers = {
    wekanode01 = "",
    wekanode02 = " C240-XPTO0000001",
    wekanode03 = " C240-XPTO0000230",
    wekanode04 = "",
    wekanode05 = "",
    wekanode06 = "",
    wekanode07 = "",
    wekanode08 = "",
    #wekanode11 = " C240-XPTO0000123",
    #wekanode12 = " C240-XPTO0000069",
 }
 */
