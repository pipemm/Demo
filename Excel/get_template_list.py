import requests
import json
from collections import OrderedDict

url_api    = 'https://create.microsoft.com/api/graphql'
url_origin = 'https://create.microsoft.com'

def request_data( offset=0, limit=50 ):
    from json import dumps
    request_dict   = OrderedDict()
    variables_dict = OrderedDict()
    variables_dict['query']   = '*'
    variables_dict['filters'] = ['content-type=excel']
    variables_dict['offset']  = offset
    variables_dict['limit']   = limit
    variables_dict['generic'] = False
    request_dict['operationName'] = 'getSearchTemplateGrid'
    request_dict['variables']     = variables_dict
    with open("query.graphql", "r") as f:
        request_dict['query'] = f.read()
    return dumps(request_dict)

request_body = request_data( )

headers = {
    "Accept": "*/*",
    "Content-Type": "application/json",
    "Origin": url_origin,
}

from urllib.request import Request, urlopen
req = Request(url=url_api, data=request_body.encode(), headers=headers)
with urlopen(req) as f:
    print(f.read().decode('utf-8'))


