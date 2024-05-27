[
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
]
