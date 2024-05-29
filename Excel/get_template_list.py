
from collections    import OrderedDict
from json           import dumps, loads
from urllib.parse   import quote
from urllib.request import Request, urlopen

url_api    = 'https://create.microsoft.com/api/graphql'
url_origin = 'https://create.microsoft.com'

def request_data( offset=0, limit=50 ):
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

headers = {
    "Accept": "*/*",
    "Content-Type": "application/json",
    "Origin": url_origin,
}


delta  = 50
offset = 0

while True:
    request_body = request_data( offset=offset, limit=delta )
    request      = Request(url=url_api, data=request_body.encode(), headers=headers)
    with urlopen(request) as f:
        response = f.read().decode()
        obj      = loads(response)
        for tt in obj['data']['searchTemplates']['templates']['templates']:
            title = tt['title']
            title = title.lower().replace(' ', '-')
            title = quote(title, safe='()')
            id    = tt['id']
            print( '{}-{}'.format(title,id) )
    if len(obj['data']['searchTemplates']['templates']['templates'])<=0:
        break
    else:
        offset += delta


