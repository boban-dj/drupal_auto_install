#!/bin/bash
 
# Directories
##########################################################
httpDir="/srv/http" # local or remote server directory root folder
rootDir="drupal_folder_name" #leave blank to set http directory as root directory.
##########################################################
 
# Site
##########################################################
siteName="Drupal_site"
siteSlogan="My_slogan"
siteLocale="gb"
##########################################################
 
# Database
##########################################################
dbHost="localhost"
dbName="drupal_database_name"
dbUser="USERNAME" # mysql user
dbPassword="PASSWD" # mysql passwd
##########################################################
 
# Admin
##########################################################
AdminUsername="admin"	# drupal site management
AdminPassword="passwd"
adminEmail="email@yahoo.com"
##########################################################
 
# Download Core
##########################################################
drush dl -y --destination=$httpDir --drupal-project-rename=$rootDir;
 

cd $httpDir/$rootDir;
 
# Install core
##########################################################
drush site-install -y standard --account-mail=$adminEmail --account-name=$AdminUsername --account-pass=$AdminPassword --site-name=$siteName --site-mail=$adminEmail --locale=$siteLocale --db-url=mysql://$dbUser:$dbPassword@$dbHost/$dbName --clean-url=0;


# --clean-url=0 ; must be set in order to login 
#or hardcode the data like so
#drush site-install standard --db-url=mysql://me:'MyPass'@localhost:3306/mydeb --account-name=admin --account-pass='pass' --account-mail=me@email.fr --site-name="Site Name" --site-mail=me@email.fr


# Download modules and themes
##########################################################
drush -y dl \
ctools \
views \
token \
fences \
panels \
metatag \
module_filter \
redirect \
globalredirect \
entity \
views_bulk_operations \
features \
strongarm \
boost \
field_group \
menu_block \
devel \
httprl \
xmlsitemap \
pathauto \
admin_menu \
backup_migrate \
jquery_update \
webform \
bootstrap-7.x-3.0;
 
# Disable some core modules
##########################################################
drush -y dis \
color \
toolbar \
shortcut \
search;
 
# Enable modules
##########################################################
drush -y en \
views \
views_ui \
token \
fences \
module_filter \
redirect \
globalredirect \
views_bulk_operations \
entity \
field_group \
pathauto \
admin_menu \
backup_migrate \
jquery_update \
webform \
admin_menu \
admin_menu_toolbar \
menu_block \
bootstrap;
 
# Pre configure settings
##########################################################
# disable user pictures
drush vset -y user_pictures 0;
# allow only admins to register users
drush vset -y user_register 0;
# set site slogan
drush vset -y site_slogan $siteSlogan;


# set files permissions sites/default/files
sudo chmod 777 /var/www/$rootDir/sites/default/files
echo -e "permissions set to chmod 777 for sites/default/files"

#todo
#if [ ! -w "$file" ]
#then
#  sudo chmod u+w "$file" && echo "The file is now writable"
#else
#  echo "The file is already writable"
#fi



# Configure JQuery update q
drush vset -y jquery_update_compression_type "min";
drush vset -y jquery_update_jquery_cdn "google";
drush -y eval "variable_set('jquery_update_jquery_version', strval(1.7));"
 
echo -e "////////////////////////////////////////////////////"
echo -e "// Install Completed"
echo -e "////////////////////////////////////////////////////"
while true; do
    read -p "press enter to exit" yn
    case $yn in
        * ) exit;;
    esac
done
