<!doctype html>
<html>
<head>
<title>UMLS Term Searc</title>
<link rel="stylesheet" href="custom.css">
</head>

<body>
<div class="top-nav"><div class="cdc-logo"><img src="cdc.png"></div></div>
<div class="container">
<h2>Term Entry</h2>
<i>Enter a term with which to poke the UMLS Metathesaurus</i> <br /><br />
    <form action="UploadTerm.jsp" method="post">
        Search Term: <input type="text" name="term1" value ="Hypertension"/>
        <br />
        <br />
        <input type="submit" value="Poke UMLS" class="upload-file"/>
    </form>
    <br/>
    <br/>
    <h2>Dual Term Entry</h2>
    <i>Enter two terms with which to poke the UMLS metathesaurus, and get the intersection of both result sets.
    <br/>
    Please note that there is a 1000 result limit to any given set.
    <br/>
    <br/>

    </i>
    <form action="UploadMultiTerms.jsp" method="post">
        Search Term 1: <input type="text" name="term1" value ="Hypertension"/>
        Search Term 2: <input type="text" name="term2" value="Heart Attack"/>
        <br /><br/>
        <input type="submit" value="Poke UMLS twice" class="upload-file"/>
    </form>
</div>


</body>
</html>
