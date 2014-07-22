declare namespace ps = "urn:x-inspire:specification:gmlas:ProtectedSites:3.0";
declare namespace gn = "urn:x-inspire:specification:gmlas:GeographicalNames:3.0";
declare namespace gml = "http://www.opengis.net/gml/3.2";


declare variable $listOfValidSrs := ('urn:ogc:def:crs:EPSG::4258', 'urn:ogc:def:crs:EPSG::4326');


<html>
  <head/>
  <body>
    <h1>List of protected sites:</h1>
    <div>
      <ul>
       {
       for $protectedSite in doc("../../data/NOR/NOR_4258.gml")//ps:ProtectedSite
       (: this is a comment :)
       
       return
           <li>{
           $protectedSite//gn:SpellingOfName/gn:text/text()}
           ({string($protectedSite/@gml:id)})
           
           {
            let $srsName := $protectedSite/ps:geometry/gml:*/@srsName,
            $isValidSrs := exists($listOfValidSrs[. = $srsName])
            
            return if (not($isValidSrs)) 
              then <b>Wrong SRS: {string($srsName)}</b>
              else <span/>
           }
           </li>
       }
     </ul>
   </div>
  </body>
</html>