<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    
    <xsl:variable name="v_names">
        <xsl:for-each-group select="mods:modsCollection//mods:name[@type='personal']" group-by="replace(.,'\W','')">
            <xsl:element name="tei:person">
                <xsl:element name="tei:persName">
                    <xsl:attribute name="xml:lang" select="'ar'"/>
                    <xsl:choose>
                        <xsl:when test="./mods:namePart[@type='given']">
                            <xsl:element name="tei:forename">
                                <xsl:value-of select="normalize-space(./mods:namePart[@type='given'])"/>
                            </xsl:element>
                            <xsl:element name="tei:surname">
                                <xsl:value-of select="normalize-space(./mods:namePart[@type='family'])"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(./mods:namePart)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:element>
        </xsl:for-each-group>
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:element name="tei:listPerson">
            <xsl:copy-of select="$v_names"/>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>