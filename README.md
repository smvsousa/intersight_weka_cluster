
# Terraform plan for Cisco Intersight and Weka.IO

The market has been seeing increased complexity and scale of the IT infrastructures to support applications accross the hybrid cloud.
This leads to the need of delivering solutions that reduce that complexity, simplify management and reduce risks.
In 2009, Cisco introduced UCS - Unified Computing System, which offered a brand new approach to infrastructure management, leveraging stateless computing hand in hand with infrastrucure programability.
Ten years later Cisco disrupted infrastructure management again with the introduction of Intersight, the hybrid cloud operation platform. Capable of managing not just UCS, Intersight is capable of delivering and managing workloads across the hybrid cloud.
Inline with its core goals of delivering agility and predictability, Intersight fully supports IaC - Infrastructure as Code, and integrates with HashiCorp's Terraform Cloud Platform.
The code here published is part of my learning process of IaC under the Intersight umbrella. 

Weka.IO offers a high performance, low latency  SDS - Software Defined Storage solution. As the data pipelines require faster access and more capacity, the need to expand the Weka.IO cluster on an automated and fast way is a clear benefit.
The plan does exactly that: create the proper Intersight Server Profiles (and respective policies) and deploy the cluster nodes.
Infrastructure is 100% defined in code ensuring compliance, predictability and agility.
Note: The plan can easily be adjusted to support any SDS solution but it is currently optimized for Weka.IO

Disclaimer 1: The code might not be brilliant: I'm not a developer. But, If I've managed to deliver it, then anyone can do it as well :)

Disclaimer 2: This is not a Cisco, Weka or HashiCorp's official tool. It is provided as is. Feel free to use it as per your own needs.



## Deploy

The code is highly commented and should be easy to understand but, in general terms:

1 - Deploy Terraform

2 - Clone repository

3 - Create an API Token on Intersight

4 - Adjust the variables. Some files have variables that you need to uncomment and adjust to your environment.

5 - Execute the plans in the right order: server_profiles, install_OS, configure_OS

Recommendation: Define the most sensitive variables on Terraform Cloud Platform.



## High Level Roadmap

- Include IMM (Intersight Management Mode) support

- Improve the Weka.io stack deployment after OS installation

- Expand configuration granularity

- Improve this README file :)

