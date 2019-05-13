<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:till="http://tillgrallert.github.io/xml"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="text" encoding="UTF-16"/>
    
    <xsl:variable name="v_url-cid" select="'http://archive.alsharekh.org/contents.aspx?CID='"/>
    <xsl:variable name="v_cid-start" select="15719"/>
    <xsl:variable name="v_cid-stop" select="15818"/>
    <xsl:variable name="v_title-journal" select="'Mawakif'"/>
    <xsl:variable name="v_url-local" select="'/Volumes/Dessau%20HD/BachUni/BachSources/mawaqif'"/>
    
    <xsl:template match="/">
        <xsl:variable name="v_increment">
            <xsl:call-template name="t_increment-cid"/>
        </xsl:variable>
        <xsl:variable name="v_list-url">
            <xsl:for-each select="$v_increment/descendant::till:url">
                <xsl:text>"</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>"</xsl:text>
                <xsl:if test="not(position()=last())">
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="v_list-url-local">
            <xsl:for-each select="$v_increment/descendant::till:urlLocal">
                <xsl:text>"</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>"</xsl:text>
                <xsl:if test="not(position()=last())">
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <!-- this will send the variable off to construct the curl script -->
        <xsl:call-template name="t_applescript">
            <xsl:with-param name="p_url-local" select="$v_list-url-local"/>
            <xsl:with-param name="p_url" select="$v_list-url"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="t_increment-cid">
        <xsl:param name="p_cid-start" select="$v_cid-start"/>
        <xsl:param name="p_cid-stop" select="$v_cid-stop"/>
        <xsl:variable name="v_url" select="concat($v_url-cid,$p_cid-start)"/>
        <xsl:element name="till:metadata">
            <xsl:element name="till:url">
            <xsl:value-of select="$v_url"/>
        </xsl:element>
        <xsl:element name="till:urlLocal">
            <xsl:value-of select="concat('/html/cid_',$p_cid-start,'.html')"/>
        </xsl:element></xsl:element>
        <xsl:if test="$p_cid-start &lt; $p_cid-stop">
            <xsl:call-template name="t_increment-cid">
                <xsl:with-param name="p_cid-start" select="$p_cid-start + 1"/>
                <xsl:with-param name="p_cid-stop" select="$p_cid-stop"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="t_applescript">
        <xsl:param name="p_url-base"/>
        <xsl:param name="p_url"/>
        <xsl:param name="p_url-local"/>
        <xsl:result-document href="{$v_title-journal}-metadata.scpt"><![CDATA[(* This script tries to download and html files for the journal Mawakif *)]]> 
            <![CDATA[
set vUrlBase to "]]><xsl:value-of select="replace($p_url-base,'\s','')" disable-output-escaping="no"/><![CDATA["]]>
            <![CDATA[
set vUrlLocalBase to "]]><xsl:value-of select="$v_url-local"/><![CDATA["]]>
            <![CDATA[
set vUrl to {]]><xsl:value-of select="$p_url"/><![CDATA[}]]>
            <![CDATA[
set vUrlLocal to {]]><xsl:value-of select="$p_url-local"/><![CDATA[}]]>
            <![CDATA[        
set vErrors to {}
        
repeat with Y from 1 to (number of items) of vUrl
	set vUrlSelected to item Y of vUrl
	set vUrlLocalSelected to item Y of vUrlLocal
	
	try
		do shell script "curl -o '" & vUrlLocalBase & vUrlLocalSelected & "' " & vUrlSelected
	on error
		set end of vErrors to vUrlSelected & ", "
		set the clipboard to vErrors as text
	end try
end repeat
]]>
<![CDATA[
tell application "TextEdit"
	make new document
	set text of document 1 to (the clipboard as text)
	save document 1 in "errors.txt"
end tell 
]]>
        </xsl:result-document>
    </xsl:template>
    
    
    
   <!-- <xsl:variable name="v_year-start" select="1969"/>
    <!-\- 1994 -\->
    <xsl:variable name="v_year-stop" select="1969"/>
    <xsl:variable name="v_issue-start" select="2"/>
    <!-\- 100 -\->
    <xsl:variable name="v_issue-stop" select="7"/>
    <xsl:variable name="v_image-start" select="1"/>
    <!-\- 400 -\->
    <xsl:variable name="v_image-stop" select="400"/>
    <xsl:variable name="v_url-base" select="'http://archive.alsharekh.org/MagazinePages%5CMagazine_JPG'"/>
    <xsl:variable name="v_url-local" select="'/Volumes/Dessau%20HD/BachUni/BachSources/muwaqif'"/>
    <xsl:variable name="v_title-journal" select="'Mawakif'"/>
    <xsl:variable name="v_url-separator" select="'%5C'"/>
    
    <xsl:template match="/">
        <xsl:variable name="v_increment">
            <xsl:call-template name="t_increment-year"/>
        </xsl:variable>
        <xsl:variable name="v_list-url">
            <xsl:for-each select="$v_increment/descendant::till:url">
                <xsl:text>"</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>"</xsl:text>
                <xsl:if test="not(position()=last())">
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="v_list-url-local">
            <xsl:for-each select="$v_increment/descendant::till:urlLocal">
                <xsl:text>"</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>"</xsl:text>
                <xsl:if test="not(position()=last())">
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <!-\- this will send the variable off to construct the curl script -\->
       <xsl:call-template name="t_applescript">
           <xsl:with-param name="p_url-local" select="$v_list-url-local"/>
           <xsl:with-param name="p_url" select="$v_list-url"/>
       </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="t_applescript">
        <xsl:param name="pUrlBase"/>
        <xsl:param name="p_url"/>
        <xsl:param name="p_url-local"/>
        <xsl:result-document href="{$v_title-journal}-v_{$v_year-start}_{$v_year-stop}-i_{$v_issue-start}_{$v_issue-stop}.scpt">
<![CDATA[(* This script tries to download and safe image files for the journal Mawakif, year(s) ]]><xsl:value-of select="$v_year-start"/><![CDATA[ to ]]><xsl:value-of select="$v_year-stop"/><![CDATA[, issue(s) ]]><xsl:value-of select="$v_issue-start"/><![CDATA[ to ]]><xsl:value-of select="$v_issue-stop"/><![CDATA[ *)]]>
           
<![CDATA[
set vUrlBase to "]]><xsl:value-of select="replace($pUrlBase,'\s','')" disable-output-escaping="no"/><![CDATA["]]>
<![CDATA[
set vUrl to {]]><xsl:value-of select="$p_url"/><![CDATA[}]]>
<![CDATA[
set vUrlLocal to {]]><xsl:value-of select="$p_url-local"/><![CDATA[}]]>
<![CDATA[        
set vErrors to {}
        
repeat with Y from 1 to (number of items) of vUrl
	set vUrlSelected to item Y of vUrl
	set vUrlLocalSelected to item Y of vUrlLocal
	
	try
		do shell script "curl -o '" & vUrlLocalSelected & "' " & vUrlSelected
	on error
		set end of vErrors to vUrlSelected & ", "
		set the clipboard to vErrors as text
	end try
end repeat
]]>
<![CDATA[
tell application "TextEdit"
	make new document
	set text of document 1 to (the clipboard as text)
	save document 1 in "errors.txt"
end tell 
]]>
        </xsl:result-document>
    </xsl:template>
    
    <!-\- increment  -\->
    <xsl:template name="t_increment-year">
        <xsl:param name="p_year-start" select="$v_year-start"/>
        <xsl:param name="p_year-stop" select="$v_year-stop"/>
        <xsl:call-template name="t_increment-issue">
            <xsl:with-param name="p_issue-start" select="$v_issue-start"/>
            <xsl:with-param name="p_issue-stop" select="$v_issue-stop"/>
            <xsl:with-param name="p_year" select="$p_year-start"/>
        </xsl:call-template>
        <xsl:if test="$p_year-start &lt; $p_year-stop">
            <xsl:call-template name="t_increment-year">
                <xsl:with-param name="p_year-start" select="$p_year-start + 1"/>
                <xsl:with-param name="p_year-stop" select="$p_year-stop"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="t_increment-issue">
        <xsl:param name="p_issue-start"/>
        <xsl:param name="p_issue-stop"/>
        <xsl:param name="p_year"/>
        <xsl:call-template name="t_increment-image">
            <xsl:with-param name="p_image-start" select="$v_image-start"/>
            <xsl:with-param name="p_image-stop" select="$v_image-stop"/>
            <xsl:with-param name="p_year" select="$p_year"/>
            <xsl:with-param name="p_issue" select="$p_issue-start"/>
        </xsl:call-template>
        <xsl:if test="$p_issue-start lt $p_issue-stop">
            <xsl:call-template name="t_increment-issue">
                <xsl:with-param name="p_issue-start" select="$p_issue-start + 1"/>
                <xsl:with-param name="p_issue-stop" select="$p_issue-stop"/>
                <xsl:with-param name="p_year" select="$p_year"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="t_increment-image">
        <xsl:param name="p_image-start"/>
        <xsl:param name="p_image-stop"/>
        <xsl:param name="p_year"/>
        <xsl:param name="p_issue"/>
        <xsl:element name="till:image">
            <xsl:attribute name="year" select="$p_year"/>
            <xsl:attribute name="issue" select="$p_issue"/>
            <xsl:attribute name="n" select="$p_image-start"/>
            <xsl:element name="till:url">
                <xsl:value-of select="concat($v_url-base,$v_url-separator,$v_title-journal,$v_url-separator,$v_title-journal,'_',$p_year,$v_url-separator,'Issue_',$p_issue,$v_url-separator,format-number($p_image-start,'000'),'.JPG')"/>
            </xsl:element>
            <xsl:element name="till:urlLocal">
                <xsl:value-of select="concat($v_url-local,'/y_',$p_year,'/i_',$p_issue,'/',format-number($p_image-start,'000'),'.jpg')"/>
            </xsl:element>
        </xsl:element>
        <xsl:if test="$p_image-start lt $p_image-stop">
            <xsl:call-template name="t_increment-image">
                <xsl:with-param name="p_image-start" select="$p_image-start + 1"/>
                <xsl:with-param name="p_image-stop" select="$p_image-stop"/>
                <xsl:with-param name="p_issue" select="$p_issue"/>
                <xsl:with-param name="p_year" select="$p_year"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>-->
    
</xsl:stylesheet>