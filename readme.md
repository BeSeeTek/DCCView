# DCC-Viewer and download server

how does this DCC server work:
with nginx or any other appropiate webserver with https and tsl this folder is served the idex.html allows the user to enter an uuid manualy.
witch then will be used to serve the coresponding dcc from the dccs folder.

all dccs there will contain an xsl transformation

```
<?xml-stylesheet type="text/xsl" href="/dccs/static/xsl/dcc.xsl"?>
```
witch will lead the browser to load the xsl stylshet from this repo witch uses the [dccviewer-js](https://www.npmjs.com/package/dccviewer-js) javascript module by Benedikt Seeger to display an interactive version of the dcc.

add this to 
nginx.conf
```nginx
  # Serve XML files with proper MIME type from /var/www/dccs/dccs
  location ~ ^/dccs/dccs/(.*\.xml)$ {
      alias /var/www/dccs/dccs/$1;
      default_type application/xml;
  }

  location ~ ^/dccs/static/xsl/(.*\.xsl)$ {
    alias /srv/Server17/dccs/static/xsl/$1;
    default_type text/xsl;
}

       # Redirect /dccs to /dccs/
    location = /dccs {
        return 301 /dccs/;
    }

    # Serve the dccs application files from /srv/Server17/dccs
  location /dccs/ {
      alias /var/www/dccs/;
      index index.html;
  }

  # Serve static assets under /dccs/static/ with caching
  location ^~ /dccs/static/ {
      alias /var/www/dccs/static/;
      expires 30d;
      add_header Cache-Control "public, no-transform";
  }
```
content of this repo
```
.
├── dccs
│   ├── 88888888-4444-4444-4444-cccccccccccc.xml
│   ├── ce5174ed-7dd5-45a9-a607-12966290f823.xml
│   └── fe245812-f6c1-4729-97fe-86b823f05825.xml
├── index.html
├── readme.md
└── static
    ├── css
    │   └── style.css
    ├── js
    │   ├── dccviewer-js.es.js
    │   └── dccviewer-js.umd.js
    └── xsl
        └── dcc.xsl
        
```

