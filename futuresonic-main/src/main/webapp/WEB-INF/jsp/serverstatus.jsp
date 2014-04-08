<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html><head>
    <%@ include file="head.jsp" %>
    <meta http-equiv="CACHE-CONTROL" content="NO-CACHE">
</head>
<body class="mainframe bgcolor1">

<h1>
    <img src="<spring:theme code="statusImage"/>" alt="">
	<fmt:message key="futuresonic.serverstatustitile"/>
    <!-- <fmt:message key="status.title"/> -->
</h1>

<table width="98%" class="ruleTable indent">

        <sub:url value="/folderChart.view" var="chartUrl1">
			<sub:param name="type" value="song"/>
		</sub:url>

        <sub:url value="/folderChart.view" var="chartUrl2">
			<sub:param name="type" value="songSize"/>
		</sub:url>		

        <sub:url value="/folderChart.view" var="chartUrl3">
			<sub:param name="type" value="video"/>
		</sub:url>		

        <sub:url value="/folderChart.view" var="chartUrl4">
			<sub:param name="type" value="videoSize"/>
		</sub:url>		

        <sub:url value="/folderChart.view" var="chartUrl5">
			<sub:param name="type" value="podcast"/>
		</sub:url>		

        <sub:url value="/folderChart.view" var="chartUrl6">
			<sub:param name="type" value="podcastSize"/>
		</sub:url>		

        <sub:url value="/folderChart.view" var="chartUrl7">
			<sub:param name="type" value="audiobook"/>
		</sub:url>		

        <sub:url value="/folderChart.view" var="chartUrl8">
			<sub:param name="type" value="audiobookSize"/>
		</sub:url>		

        <sub:url value="/folderChart.view" var="chartUrl9">
			<sub:param name="type" value="album"/>
		</sub:url>		
		
		<tr>
		<td style="width:100px; border: 1px;"><fmt:message key="futuresonic.serverstatusalbums"/></td>
			<td style="border: 1px;" class="ruleTableCell" width="${model.chartWidth}"><img width="${model.chartWidth}" height="${model.chartHeight}" src="${chartUrl9}" alt=""></td>
		</tr>
		<tr>
		<td><fmt:message key="futuresonic.serverstatusaudiofiles"/></td>
			<td style="border: 1px;" class="ruleTableCell" width="${model.chartWidth}"><img width="${model.chartWidth}" height="${model.chartHeight}" src="${chartUrl1}" alt=""></td>
		</tr>
		<tr>
		<td><fmt:message key="futuresonic.serverstatusaudiosizemb"/></td>
			<td style="border: 1px;" class="ruleTableCell" width="${model.chartWidth}"><img width="${model.chartWidth}" height="${model.chartHeight}" src="${chartUrl2}" alt=""></td>
		</tr>
		<tr>
		<td><fmt:message key="futuresonic.serverstatusvideofiles"/></td>
			<td style="border: 1px;" class="ruleTableCell" width="${model.chartWidth}"><img width="${model.chartWidth}" height="${model.chartHeight}" src="${chartUrl3}" alt=""></td>
		</tr>
		<tr>
		<td><fmt:message key="futuresonic.serverstatusvideofilesizemb"/></td>
			<td style="border: 1px;" class="ruleTableCell" width="${model.chartWidth}"><img width="${model.chartWidth}" height="${model.chartHeight}" src="${chartUrl4}" alt=""></td>
		</tr>
		<tr>
		<td><fmt:message key="futuresonic.serverstatuspocasts"/></td>
			<td style="border: 1px;" class="ruleTableCell" width="${model.chartWidth}"><img width="${model.chartWidth}" height="${model.chartHeight}" src="${chartUrl5}" alt=""></td>
		</tr>
		<tr>
		<td><fmt:message key="futuresonic.serverstatuspodcastssizemb"/></td>
			<td style="border: 1px;" class="ruleTableCell" width="${model.chartWidth}"><img width="${model.chartWidth}" height="${model.chartHeight}" src="${chartUrl6}" alt=""></td>
		</tr>
		<tr>
		<td><fmt:message key="futuresonic.serverstatusaudiobooks"/></td>
			<td style="border: 1px;" class="ruleTableCell" width="${model.chartWidth}"><img width="${model.chartWidth}" height="${model.chartHeight}" src="${chartUrl7}" alt=""></td>
		</tr>
		<tr>
		<td><fmt:message key="futuresonic.serverstatusaudiobooksfilesizemb"/></td>
			<td style="border: 1px;" class="ruleTableCell" width="${model.chartWidth}"><img width="${model.chartWidth}" height="${model.chartHeight}" src="${chartUrl8}" alt=""></td>
		</tr>
		
</table>
<div class="forward"><a href="serverStatus.view?"><fmt:message key="common.refresh"/></a></div>
</body></html>