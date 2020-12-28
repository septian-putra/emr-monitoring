#!/bin/sh

set -x

if [ -f /etc/jupyter/conf/jupyterhub_config.py ]; then

   if grep -q 'c.JupyterHub.api_tokens' /etc/jupyter/conf/jupyterhub_config.py ; then
      echo "Api Token already exists for the Admin user"
   else

      if grep -q 'c.Authenticator.admin_users' /etc/jupyter/conf/jupyterhub_config.py ; then

        admin_token=`openssl rand -hex 32`
        admin_token="'${admin_token}'"
        echo $admin_token

        admin_users=`cat /etc/jupyter/conf/jupyterhub_config.py | grep 'c.Authenticator.admin_users' | awk '{print $3}'`

        users=`echo $admin_users | awk '{print substr($0, 2, length($0) - 2)}'`
        lstusers=`echo $users | tr "," "\n"`

        for usr in $lstusers
        do
          #admin_user=`echo  $usr | awk '{print substr($0, 2, length($0) - 2)}'`
          admin_user=$(echo $usr)
          break
        done

        echo $admin_user

        sudo bash -c 'echo "c.JupyterHub.api_tokens = {" >> /etc/jupyter/conf/jupyterhub_config.py'
        sudo bash -c 'echo "    '$admin_token' : '$admin_user'," >> /etc/jupyter/conf/jupyterhub_config.py'
        sudo bash -c 'echo "}" >> /etc/jupyter/conf/jupyterhub_config.py'

        sudo docker stop jupyterhub
        sudo docker start jupyterhub

      else
        echo "No admin users - API Token cannot be configured"
      fi
   fi
fi