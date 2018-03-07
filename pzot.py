#!/usr/bin/env python
# -*- coding: utf-8 -*-

# J700SX5Nv2PxA5N3AvGrx7xq

from pyzotero import zotero
zot = zotero.Zotero('3187747', 'user', 'J700SX5Nv2PxA5N3AvGrx7xq')
# we now have a Zotero object, zot, and access to all its methods
first_ten = zot.items(limit=10)
# a list containing dicts of the ten most recently modified library items
#for item in items:
#        print('Item: %s | Key: %s') % (item['data']['itemType'], item['data']['key'])

first_item = zot.top(limit=1)
# now we can start retrieving subsequent items
print (first_item[0][1])
next_item = zot.follow()
third_item = zot.follow()
