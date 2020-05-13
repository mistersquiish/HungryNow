#!/bin/sh

#  CurlCommands.sh
#  HungryNow
#
#  Created by Henry Vuong on 4/10/20.
#  Copyright © 2020 Henry Vuong. All rights reserved.

curl -H "Authorization: Bearer KT_bxS5gMkwkqOweJ-DLtwJg3WaTwwLvQhaPINQgx7bGHyP3EZi_K7ZjfmCfD9xPXE8ACtxjseKOchixoxxTrsyjQjtqVmeyJiLGQ8Km9DYGF9bwD_BXx35bb3OPXnYx" --request GET "https://api.yelp.com/v3/businesses/search?term=mcdonalds&latitude=30000.2672&longitude=-97.7431"

curl -H "Authorization: Bearer KT_bxS5gMkwkqOweJ-DLtwJg3WaTwwLvQhaPINQgx7bGHyP3EZi_K7ZjfmCfD9xPXE8ACtxjseKOchixoxxTrsyjQjtqVmeyJiLGQ8Km9DYGF9bwD_BXx35bb3OPXnYx" --request GET "https://api.yelp.com/v3/businesses/search"
