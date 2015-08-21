<%--
  Created by IntelliJ IDEA.
  User: PMW3
  Date: 7/8/15
  Time: 3:18 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="org.apache.commons.fileupload.*,org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
<%@ page import="org.apache.poi.util.*" %>
<%@ page import="org.apache.poi.xslf.usermodel.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.*" %>
<%@ page import="gov.nih.nlm.uts.webservice.content.*" %>
<%@ page import="gov.nih.nlm.uts.webservice.finder.*" %>
<%@ page import="gov.nih.nlm.uts.webservice.history.*" %>
<%@ page import="gov.nih.nlm.uts.webservice.metadata.*" %>
<%@ page import="gov.nih.nlm.uts.webservice.security.*" %>
<%@ page import="gov.nih.nlm.uts.webservice.semnet.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>


<%
    String result = "";
    Properties prop = new Properties();
    ServletContext context = pageContext.getServletContext();
    String propFileName = context.getInitParameter("properties-file");;

    InputStream inputStream = new FileInputStream(propFileName);

    if (inputStream != null) {
        prop.load(inputStream);
    } else {
        throw new FileNotFoundException("property file '" + propFileName + "' not found in the classpath");
    }
    // Runtime properties
    //String username = args[0];
    String username = prop.getProperty("user");
    //String password = args[1];
    String password = prop.getProperty("password");
    //String umlsRelease = args[2];
    String umlsRelease = "2.0";
    String serviceName = "http://umlsks.nlm.nih.gov";

    UtsWsMetadataController utsMetaController = (new UtsWsMetadataControllerImplService()).getUtsWsMetadataControllerImplPort();


    UtsWsContentController utsContentService = (new UtsWsContentControllerImplService()).getUtsWsContentControllerImplPort();
    UtsWsSecurityController securityService = (new UtsWsSecurityControllerImplService()).getUtsWsSecurityControllerImplPort();

    //get the Proxy Grant Ticket - this is good for 8 hours and is needed to generate single use tickets.
    String ticketGrantingTicket = securityService.getProxyGrantTicket(username, password);

    //build some ConceptDTOs and retrieve UI and Default Preferred Name

    //use the Proxy Grant Ticket to get a Single Use Ticket
    String singleUseTicket0 = securityService.getProxyTicket(ticketGrantingTicket, serviceName);

    umlsRelease = utsMetaController.getCurrentUMLSVersion(singleUseTicket0);
    String singleUseTicket1 = securityService.getProxyTicket(ticketGrantingTicket, serviceName);
  String term1 = request.getParameter("term1");


    gov.nih.nlm.uts.webservice.finder.Psf myPsf = new gov.nih.nlm.uts.webservice.finder.Psf();
    myPsf.setPageLn(2000);
    List<UiLabel> myUiLabels = new ArrayList<UiLabel>();

    UtsWsFinderController UtsFinderService = (new UtsWsFinderControllerImplService()).getUtsWsFinderControllerImplPort();
    myUiLabels = UtsFinderService.findConcepts(singleUseTicket1, umlsRelease, "atom", term1,  "words", myPsf);

    String term2 = request.getParameter("term2");
    List<UiLabel> myUiLabels2 = new ArrayList<UiLabel>();
    String singleUseTicket2 = securityService.getProxyTicket(ticketGrantingTicket, serviceName);
    myUiLabels2 = UtsFinderService.findConcepts(singleUseTicket2, umlsRelease, "atom", term2,  "words", myPsf);



 %>

    <html>
    <head>
    <title>File Preview</title>
        <link rel="stylesheet" href="custom.css">
    </head>
    <body>
    <div class="top-nav"><div class="cdc-logo"><img src="cdc.png"></div></div>
    <div class="container">
    <%
        HashMap<String, String> setDump = new HashMap<String, String>();

        %>
        The number of results returned for "<%=term1%>" is <%=myUiLabels.size()%> and
        the number of results returned for "<%=term2%>" is <%=myUiLabels2.size()%> <br> <br>
        <%
     if(!myUiLabels2.isEmpty() && !myUiLabels.isEmpty()) {
         HashMap<String, String> listDump = new HashMap<String, String>();

         for (int i = 0; i < myUiLabels2.size(); i++) {
             UiLabel myUiLabel = myUiLabels2.get(i);
             String ui = myUiLabel.getUi();
             String label = myUiLabel.getLabel();
             listDump.put(ui, label);
         }
         for (int i = 0; i < myUiLabels.size(); i++) {
             UiLabel myUiLabel = myUiLabels.get(i);
             String ui = myUiLabel.getUi();
             String label = myUiLabel.getLabel();
             if (listDump.containsKey(ui)) {
                 setDump.put(ui, label);
             }
         }
     }
            if(!setDump.isEmpty())
            {

                Iterator<String> seti = setDump.keySet().iterator();
                while(seti.hasNext())
                {
                    String ui = seti.next();
                    String label = setDump.get(ui);
             %>
           UI: <%=ui%> Label: <%=label%> <br>
        <%
         }

  }else{ %>
    <p>No results returned, please try again from <a href="../umlsite/">the beginning</a></p>

    <%
  }
%>
        </div>
</body>
</html>