#!/usr/bin/env python
# -*- encoding: utf-8 -*-
"""Install a module"""

import xmlrpclib
import argparse
import getpass

parser = argparse.ArgumentParser()
# Connection args
parser.add_argument('-d', '--database', help="Use DB as the database name",
                    action='store', metavar='DB', default=getpass.getuser())
parser.add_argument('-u', '--user', help="Use USER as the database user name",
                    action='store', metavar='USER', default='admin')
parser.add_argument('-w', '--password',
                    help="Use PASSWORD as the database password.",
                    action='store', metavar='PASSWORD', default='admin')
parser.add_argument('-s', '--url',
                    help="Point to the web services hosted at URL",
                    action='store', metavar='URL',
                    default='http://localhost:8069')

args = vars(parser.parse_args())

# Log in
ws_common = xmlrpclib.ServerProxy(args['url'] + '/xmlrpc/common')
uid = ws_common.login(args['database'], args['user'], args['password'])
print "Logged in to the common web service."
# Get the object proxy
ws_object = xmlrpclib.ServerProxy(args['url'] + '/xmlrpc/object')
print "Connected to the object web service."


# Update the module lsit
print "Updating module list"
ws_object.execute(
    args['database'], uid, args['password'],
    'nace.import', "run_import",[1])

print "Well done."
