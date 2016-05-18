<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:till="http://tillgrallert.github.io/xml"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:include href="mawaqif-images-functions.xsl"/>
    
    <xsl:variable name="v_year-start" select="1971"/>
    <!-- 1994 -->
    <xsl:variable name="v_year-stop" select="1971"/>
    <xsl:variable name="v_issue-start" select="14"/>
    <!-- 100 -->
    <xsl:variable name="v_issue-stop" select="17"/>
  
    
    <xsl:template match="/">
        <xsl:variable name="v_increment">
            <xsl:call-template name="t_increment-year">
                <xsl:with-param name="p_year-start" select="$v_year-start"/>
                <xsl:with-param name="p_year-stop" select="$v_year-stop"/>
                <xsl:with-param name="p_issue-start" select="$v_issue-start"/>
                <xsl:with-param name="p_issue-stop" select="$v_issue-stop"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="v_list-url">
            <xsl:for-each select="$v_increment/descendant::till:url">
                <xsl:text>"</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>"</xsl:text>
                <xsl:if test="not(position()=last())">
                    <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="v_list-url-local">
            <xsl:for-each select="$v_increment/descendant::till:urlLocal">
                <xsl:text>"</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>"</xsl:text>
                <xsl:if test="not(position()=last())">
                    <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <!-- this will send the variable off to construct the curl script -->
        <xsl:result-document href="{$v_title-journal}-v_{$v_year-start}_{$v_year-stop}-i_{$v_issue-start}_{$v_issue-stop}.scpt" method="text">
            <xsl:call-template name="t_applescript">
                <xsl:with-param name="p_url-local" select="$v_list-url-local"/>
                <xsl:with-param name="p_url" select="$v_list-url"/>
            </xsl:call-template>
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>