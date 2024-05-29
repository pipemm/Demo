import requests
import json
from collections import OrderedDict

url_api = 'https://create.microsoft.com/api/graphql'

with open("request.ql", "r") as f:
    request_body = f.read()

def req( offset=0, limit=50 ):
    from json import dumps
    request_dict   = OrderedDict()
    variables_dict = OrderedDict()
    request_dict['operationName'] = 'getSearchTemplateGrid'
    variables_dict['query']       = '*'
    variables_dict['filters']     = ['content-type=excel']
    variables_dict['offset']      = 0
    variables_dict['limit']       = 50
    variables_dict['generic']     = False
    request_dict['variables']     = variables_dict
    request_dict['query']         = "query getSearchTemplateGrid($query: String!, $filters: [String!], $offset: Int, $limit: Int, $locale: String, $generic: Boolean, $collectionId: String, $orderSeed: String) {\n searchTemplates(\n query: $query\n filters: $filters\n locale: $locale\n offset: $offset\n limit: $limit\n generic: $generic\n collectionId: $collectionId\n orderSeed: $orderSeed\n ) {\n id\n ...SearchTemplateGrid_searchTemplates\n __typename\n }\n}\n\nfragment SearchTemplateGrid_searchTemplates on SearchTemplates {\n templates {\n templates {\n id\n ...TemplateThumbnailCard_template\n __typename\n }\n __typename\n }\n totalCount\n searchStatus\n __typename\n}\n\nfragment TemplateThumbnailCard_template on Template {\n title\n longFormTitle\n premium\n templateContentType\n __typename\n}"
    return dumps(request_dict)

request_body = r"""
    {
        "operationName": "getSearchTemplateGrid",
        "variables": {
            "query": "*",
            "filters": [
                "content-type=excel"
            ],
            "offset": 0,
            "limit": 50,
            "generic": false
        },
        "query": "query getSearchTemplateGrid($query: String!, $filters: [String!], $offset: Int, $limit: Int, $locale: String, $generic: Boolean, $collectionId: String, $orderSeed: String) {\n searchTemplates(\n query: $query\n filters: $filters\n locale: $locale\n offset: $offset\n limit: $limit\n generic: $generic\n collectionId: $collectionId\n orderSeed: $orderSeed\n ) {\n id\n ...SearchTemplateGrid_searchTemplates\n __typename\n }\n}\n\nfragment SearchTemplateGrid_searchTemplates on SearchTemplates {\n templates {\n templates {\n id\n ...TemplateThumbnailCard_template\n __typename\n }\n __typename\n }\n totalCount\n searchStatus\n __typename\n}\n\nfragment TemplateThumbnailCard_template on Template {\n title\n longFormTitle\n premium\n templateContentType\n __typename\n}"
    }
"""

headers = {
    "Accept": "*/*",
    "Content-Type": "application/json",
    "Origin": "https://create.microsoft.com",
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36",
}

print( req() )

#response = requests.post(url_api, headers=headers, data=request_body)


#if response.status_code == 200:
#    print("Success! Response:", response.json())
#else:
#    print("Error:", response.status_code, response.text)
