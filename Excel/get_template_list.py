
from collections    import OrderedDict
from json           import dumps, loads
from urllib.parse   import quote
from urllib.request import Request, urlopen

url_api    = 'https://create.microsoft.com/api/graphql'

def request_data( offset=0, limit=50, query=None ):
    request_dict   = OrderedDict()
    variables_dict = OrderedDict()
    variables_dict['query']   = '*'
    variables_dict['filters'] = ['content-type=excel']
    variables_dict['offset']  = offset
    variables_dict['limit']   = limit
    variables_dict['generic'] = False
    request_dict['operationName'] = 'getSearchTemplateGrid'
    request_dict['variables']     = variables_dict
    if query is not None:
        request_dict['query'] = query
    return dumps(request_dict)

def get_header():
    from urllib.parse import urlparse
    o          = urlparse(url_api)
    url_origin = o._replace(path='', params='', query='', fragment='').geturl()
    return {
        "Accept": "*/*",
        "Content-Type": "application/json",
        "Origin": url_origin,
    }

def get_query():
    from sys      import argv
    from os.path  import isfile
    if len(argv)>=2:
        file_query = argv[1]
    else:
        return None
    if isfile(file_query):
        with open(file_query, 'r') as f:
            return f.read()

delta  = 50
offset = 0

headers = get_header()

def main():

    delta  = 50
    offset = 0

    headers = get_header()
    query   = get_query()

    while True:
        request_body = request_data( offset=offset, limit=delta, query=query )
        request      = Request(url=url_api, data=request_body.encode(), headers=headers)
        with urlopen(request) as f:
            response = f.read().decode()
            obj      = loads(response)
            for tt in obj['data']['searchTemplates']['templates']['templates']:
                title = tt['title']
                name  = title.lower().replace(' ', '-')
                name = quote(name, safe='()')
                id    = tt['id']
                print( '{}-{}   {}'.format(name,id,title) )
        if len(obj['data']['searchTemplates']['templates']['templates'])<=0:
            break
        else:
            offset += delta

if __name__ = '__main__':
    main()

