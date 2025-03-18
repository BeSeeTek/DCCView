<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet id="dccViewer" version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dcc="https://ptb.de/dcc"
    xmlns:exsl="http://exslt.org/common">

  <!-- Remove extra whitespace -->
  <xsl:strip-space elements="*"/>

  <!-- Output HTML -->
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <!-- Template for the root node -->
  <xsl:template match="/">
    <html>
      <head>
        <meta charset="UTF-8"/>
        <title>DCC Viewer</title>
        <!-- Link to your production CSS -->
        <link rel="stylesheet" type="text/css" href="/dccs/static/css/style.css"/>
      </head>
      <body>
        <div id="app"></div>
        <!-- Embed the certificate XML into a hidden script block -->
        <script id="xmlContent" type="application/xml">
          <xsl:copy-of select="dcc:digitalCalibrationCertificate"/>
        </script>
        <script>
          window.process = { env: {} };
        </script>
        <!-- Load and initialize your JavaScript application -->
        <script type="module">
          <![CDATA[
            import { init } from '/dccs/static/js/dccviewer-js.es.js';

            // Retrieve the raw text content from the script tag.
            // Note: The XML is output as HTML, so it may be escaped.
            const xmlContentElem = document.getElementById('xmlContent');
            const rawXmlEscaped = xmlContentElem.textContent.trim();
            console.log('Escaped XML from DOM:', rawXmlEscaped);

            // Use DOMParser to convert the escaped XML back into a proper XML Document.
            const parser = new DOMParser();
            const xmlDoc = parser.parseFromString(rawXmlEscaped, 'application/xml');

            // Check if the parsing returned an error
            if(xmlDoc.getElementsByTagName('parsererror').length > 0) {
              console.error("XML Parsing Error:", xmlDoc.getElementsByTagName('parsererror')[0].textContent);
            }

            // Serialize the XML Document back to a string
            const serializedXml = new XMLSerializer().serializeToString(xmlDoc);
            console.log('Serialized XML:', serializedXml);

            // Initialize the application with the proper XML string.
            init(serializedXml, { containerId: 'app', language: 'en' });
          ]]>
        </script>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
