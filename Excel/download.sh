#!/usr/bin/bash

url_index='https://create.microsoft.com/en-us/search?filters=excel'

curl "${url_index}"


curl 'https://create.microsoft.com/api/graphql' \
  -H 'accept: */*' \
  -H 'accept-language: en-us' \
  -H 'content-type: application/json' \
  -H 'origin: https://create.microsoft.com' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36' \
  --data-raw $'[{"operationName":"getSearchTemplateGrid","variables":{"query":"*","filters":["content-type=excel"],"locale":"en-us","offset":0,"limit":50,"generic":false},"query":"query getSearchTemplateGrid($query: String\u0021, $filters: [String\u0021], $offset: Int, $limit: Int, $locale: String, $generic: Boolean, $collectionId: String, $orderSeed: String) {\\n  searchTemplates(\\n    query: $query\\n    filters: $filters\\n    locale: $locale\\n    offset: $offset\\n    limit: $limit\\n    generic: $generic\\n    collectionId: $collectionId\\n    orderSeed: $orderSeed\\n  ) {\\n    id\\n    ...SearchTemplateGrid_searchTemplates\\n    __typename\\n  }\\n  componentContent {\\n    id\\n    ...SearchTemplateGrid_componentContent\\n    __typename\\n  }\\n}\\n\\nfragment SearchTemplateGrid_searchTemplates on SearchTemplates {\\n  templates {\\n    templates {\\n      id\\n      ...TemplateThumbnailCard_template\\n      __typename\\n    }\\n    __typename\\n  }\\n  totalCount\\n  searchStatus\\n  __typename\\n}\\n\\nfragment SearchTemplateGrid_componentContent on ComponentContent {\\n  ...TemplateThumbnailCard_componentContent\\n  ...noResultsHeading_ComponentContent\\n  __typename\\n}\\n\\nfragment TemplateThumbnailCard_template on Template {\\n  title\\n  longFormTitle\\n  premium\\n  templateContentType\\n  ...TemplateThumbnail_template\\n  ...TemplateThumbnailActions_template\\n  __typename\\n}\\n\\nfragment TemplateThumbnail_template on Template {\\n  thumbnails {\\n    alt\\n    height\\n    size\\n    uri\\n    width\\n    contentType\\n    __typename\\n  }\\n  __typename\\n}\\n\\nfragment TemplateThumbnailActions_template on Template {\\n  ...TemplateThumbnailContentTypeLabel_template\\n  __typename\\n}\\n\\nfragment TemplateThumbnailContentTypeLabel_template on Template {\\n  templateContentType\\n  supportingApplication\\n  __typename\\n}\\n\\nfragment TemplateThumbnailCard_componentContent on ComponentContent {\\n  ...TemplateThumbnailActions_componentContent\\n  __typename\\n}\\n\\nfragment TemplateThumbnailActions_componentContent on ComponentContent {\\n  ...TemplateThumbnailContentTypeLabel_componentContent\\n  __typename\\n}\\n\\nfragment TemplateThumbnailContentTypeLabel_componentContent on ComponentContent {\\n  templateThumbnailOverlay {\\n    ctaLabelPrefix\\n    __typename\\n  }\\n  __typename\\n}\\n\\nfragment noResultsHeading_ComponentContent on ComponentContent {\\n  noSearchResults {\\n    heading\\n    subheading\\n    __typename\\n  }\\n  __typename\\n}"}]' > test.json