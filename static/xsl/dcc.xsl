<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet id="embeddedXSL" version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exsl="http://exslt.org/common"
    xmlns:dcc="https://ptb.de/dcc">

  <!-- Remove extra whitespace -->
  <xsl:strip-space elements="*"/>

  <!-- Output HTML for browser rendering -->
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <!-- Template for the root node -->
  <xsl:template match="/">
    <html>
      <head>
        <meta charset="UTF-8"/>
        <title>DCC Viewer</title>
        <!-- Link to production CSS -->
        <link rel="stylesheet" type="text/css" href="/dccs/static/css/style.css"/>
      </head>
      <body>
        <div id="app"></div>
        <!-- Embed the certificate XML into a hidden textarea to preserve the raw XML -->
        <textarea id="xmlContent" style="display:none;"><xsl:copy-of select="dcc:digitalCalibrationCertificate"/></textarea>
        <script id="xmlContentScript" type="application/xml">
          <xsl:copy-of select="dcc:digitalCalibrationCertificate"/>
        </script>
        <script>
          window.process = { env: {} };
        </script>
        <!-- Load and initialize your JavaScript application with enhanced debugging -->
        <script type="module">
          <![CDATA[
            import { init } from '/dccs/static/js/dccviewer-js.es.js';

            // Retrieve the embedded XML from the textarea.
            const elem = document.getElementById('xmlContent');
            let rawXml = elem.value.trim();
            if(rawXml === ''){
              console.log('DEBUG: elem.value is empty. Falling back to elem.textContent.');
              const xmlNode = document.getElementById('xmlContentScript').firstChild;
              rawXml = new XMLSerializer().serializeToString(xmlNode);
              console.log('Serialized XML:', rawXml);
              if(rawXml){
                rawXml = rawXml.trim();
                console.log('DEBUG: Retrieved rawXml from textContent:', rawXml);
              } else {
                console.error('DEBUG: Both elem.value and elem.textContent are empty!');
              }
            } else {
              console.log('DEBUG: Retrieved rawXml from elem.value:', rawXml);
            }

            // Check if rawXml appears to contain XML tags
            if (rawXml.indexOf('<') === -1) {
              console.error('DEBUG: rawXml does not contain any tags. It may be corrupted or empty:', rawXml);
            }

            // Replace stray ampersands with the proper escaped sequence.
            const fixedXml = rawXml.replace(/&(?!amp;|lt;|gt;|apos;|quot;)/g, '&amp;');
            console.log('DEBUG: fixedXml after replacing stray ampersands:', fixedXml);

            // Optionally, try parsing the XML to verify its structure
            const parser = new DOMParser();
            const xmlDoc = parser.parseFromString(fixedXml, 'application/xml');
            if(xmlDoc.getElementsByTagName('parsererror').length > 0){
              console.error('DEBUG: XML Parsing Error:', xmlDoc.getElementsByTagName('parsererror')[0].textContent);
            } else {
              console.log('DEBUG: XML parsed successfully.');
            }

            // Finally, initialize your application with the fixed XML string.
            init(fixedXml, { containerId: 'app', language: 'en' });
          ]]>
        </script>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
