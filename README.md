# terraform 101- let's make it simple

This guide will allow you to start a terraform with a backend inside azute then AWS

the plan is also to go over modules
have fun.
<pre>
you'll need to create a secret.tf file (not supplied) - for the machines.
variable "admin_username" {
  default = ""
}
variable "admin_password" {
  default = ""
}
</pre>

ssh-keygen -y -f weightapp.pem > weightapp.pub 