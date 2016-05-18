<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:till="http://tillgrallert.github.io/xml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8" version="1.0"/>

    <xsl:include href="mawaqif-images-functions.xsl"/>

    <xsl:variable name="v_id-facs" select="'facs_'"/>

    <xsl:template match="html:html">
        <!-- some variables -->
        <xsl:variable name="v_title-journal" select="'مواقف'"/>
        <xsl:variable name="v_year">
            <xsl:analyze-string select=".//*[@id = 'ContentPlaceHolder1_fvIssueInfo_Label1']" regex="(\d{{4}})">
                <xsl:matching-substring>
                    <xsl:value-of select="number(regex-group(1))"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <xsl:variable name="v_issue">
            <xsl:analyze-string select=".//*[@id = 'ContentPlaceHolder1_fvIssueInfo_lbissuenumber']" regex="(\d+)">
                <xsl:matching-substring>
                    <xsl:value-of select="number(regex-group(1))"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <xsl:variable name="v_increment">
            <xsl:call-template name="t_increment-image">
                <xsl:with-param name="p_image-start" select="1"/>
                <xsl:with-param name="p_image-stop" select="300"/>
                <xsl:with-param name="p_issue" select="$v_issue"/>
                <xsl:with-param name="p_year" select="$v_year"/>
            </xsl:call-template>
        </xsl:variable>
        <!-- check, if the cid points to the correct journal -->
        <xsl:if test="descendant::html:td[@class='F_MagazineName']/html:table/html:tr[1]//html:a/@href='newmagazineYears.aspx?MID=11'">
        <!-- build the output -->
        <xsl:result-document href="../xml/oclc_792755362-i_{$v_issue}.TEIP5.xml">
            <xsl:value-of
                select="'&lt;?xml-stylesheet type=&quot;text/xsl&quot; href=&quot;https://rawgit.com/tillgrallert/tei-boilerplate-arabic-editions/online/xslt-boilerplate/teibp.xsl&quot;?>'"
                disable-output-escaping="yes"/>
            <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:id="oclc_792755362-i_{$v_issue}">
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title xml:lang="ar-Latn-x-ijmes">Mawāqif</title>
                            <respStmt xml:lang="ar">
                                <resp>TEI edition</resp>
                                <persName xml:id="pers_TG">
                                    <forename>Till</forename>
                                    <surname>Grallert</surname>
                                </persName>
                            </respStmt>
                        </titleStmt>
                        <publicationStmt xml:lang="en">
                            <authority xml:lang="en">
                                <persName xml:lang="en">Till Grallert</persName>
                            </authority>
                            <pubPlace xml:lang="en">Beirut</pubPlace>
                            <date when="2016" xml:lang="en">2016</date>
                            <availability status="restricted" xml:lang="en">
                                <licence target="http://creativecommons.org/licenses/by-sa/4.0/" xml:lang="en">The XML file is distributed under
                                    a Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0) license</licence>
                            </availability>
                            <idno type="url">
                                <xsl:value-of
                                    select="concat('https://github.com/tillgrallert/digital-muqtabas/blob/master/xml/oclc_792755362-i_', $v_issue, '.TEIP5.xml')"
                                />
                            </idno>
                        </publicationStmt>
                        <sourceDesc>
                            <biblStruct xml:lang="en">
                                <monogr xml:lang="en">
                                    <title level="j" xml:lang="ar">مواقف</title>
                                    <title level="j" type="sub" xml:lang="ar">للحرية، والإبداع، والتغير</title>
                                    <title level="j" xml:lang="ar-Latn-x-ijmes">Mawāqif</title>
                                    <title level="j" type="sub" xml:lang="ar-Latn-x-ijmes">li-l-ḥurriyya, wa-l-ibdāʿ wa-l-taghayyur</title>
                                    <editor ref="https://viaf.org/viaf/32272677">
                                        <persName xml:lang="ar">أدونيس</persName>
                                        <persName xml:lang="ar-Latn-x-ijmes">Adonis</persName>
                                    </editor>
                                    <imprint xml:lang="en">
                                        <pubPlace xml:lang="en">
                                            <placeName xml:lang="ar">بيروت</placeName>
                                            <placeName xml:lang="ar-Latn-x-ijmes">Bayrūt</placeName>
                                            <placeName xml:lang="en">Beirut</placeName>
                                        </pubPlace>
                                        <date when="{$v_year}" xml:lang="ar">
                                            <xsl:value-of select=".//*[@id = 'ContentPlaceHolder1_fvIssueInfo_Label1']"/>
                                        </date>
                                    </imprint>
                                    <biblScope unit="volume" n="{$v_year}"/>
                                    <biblScope unit="issue" n="{$v_issue}"/>
                                    <biblScope unit="page" from="1" to=""/>
                                </monogr>
                                <idno type="oclc" xml:lang="en">792755362</idno>
                                <idno type="sakhrit" xml:lang="en">
                                    <xsl:value-of select="replace(base-uri(.),'.*/cid_(\d+)\.html','http://archive.sakhrit.co/contents.aspx?CID=$1')"/>
                                </idno>
                            </biblStruct>
                        </sourceDesc>
                    </fileDesc>
                    <!-- According to TEI P5 @xml:lang should follow BCP 47 <note target="http://www.iana.org/assignments/language-subtag-registry/language-subtag-registry"/>, which specifies for Arabic in Latin transcription "ar-Latn". The specific type of transcription should be added as a private use subtag, i.e. "ar-Latn-x-ijmes" for the
               IJMES transcription of Arabic in Latin script. -->
                    <profileDesc>
                        <langUsage xml:lang="en">
                            <language ident="ar" xml:lang="en">Arabic</language>
                            <language ident="ar-Latn-x-ijmes" xml:lang="en">Arabic transcribed into Latin script following the IJMES
                                conventions</language>
                            <language ident="ar-Latn-EN" xml:lang="en">Arabic transcribed into Latin script following common English
                                practices</language>
                            <language ident="ar-Latn-FR" xml:lang="en">Arabic transcribed into Latin script following common French
                                practices</language>
                            <language ident="en" xml:lang="en">English</language>
                            <language ident="fa" xml:lang="en">Farsi</language>
                            <language ident="fa-Latn-x-ijmes" xml:lang="en">Farsi transcribed into Latin script following the IJMES
                                conventions</language>
                            <language ident="fr" xml:lang="en">French</language>
                            <language ident="ota" xml:lang="en">Ottoman</language>
                            <language ident="ota-Latn-x-ijmes" xml:lang="en">Ottoman transcribed into Latin script following the IJMES
                                conventions</language>
                            <language ident="tr" xml:lang="en">Turkish</language>
                            <language ident="en-Arab-AR" xml:lang="en">English transcribed into Arabic script following common Levantine Arabic
                                practices</language>
                            <language ident="fr-Arab-AR" xml:lang="en">French transcribed into Arabic script following common Levantine Arabic
                                practices</language>
                        </langUsage>
                    </profileDesc>
                    <revisionDesc>
                        <change when="{format-date(current-date(),'[Y0001]-[M01]-[D01]')}" who="#pers_TG">Created this TEI P5 file by automatic conversion of the table of content from 
                            HTML available at archive.sakhrit.co and adding a computed sequence of facsimiles linking to the same website.</change>
                    </revisionDesc>
                </teiHeader>
                <facsimile>
                    <xsl:apply-templates select="$v_increment/descendant-or-self::till:image"/>
                </facsimile>
                <text xml:lang="ar">
                    <front>
                        <div>
                            <bibl>
                                <title level="j">
                                    <xsl:value-of select="$v_title-journal"/>
                                </title>
                                <biblScope unit="issue" n="{$v_issue}">
                                    <xsl:value-of select=".//*[@id = 'ContentPlaceHolder1_fvIssueInfo_lbissuenumber']"/>
                                </biblScope>
                                <date when="{$v_year}">
                                    <xsl:value-of select=".//*[@id = 'ContentPlaceHolder1_fvIssueInfo_Label1']"/>
                                </date>
                            </bibl>
                        </div>
                        <!-- test if a table of content, front matter should be provided -->
                        <xsl:variable name="v_pb-start" select="number(normalize-space(descendant::html:table[@id = 'ContentPlaceHolder1_dlIndexs']/html:tr[html:td[position() = 6]][1]/html:td[position() = 6]))"/>
                        <xsl:if test="$v_pb-start &gt; 1">
                            <xsl:call-template name="t_generate-pb">
                                <xsl:with-param name="p_pb-start" select="1"/>
                                <xsl:with-param name="p_pb-stop" select="1"/>
                            </xsl:call-template>
                            <div>
                                <xsl:call-template name="t_generate-pb">
                                    <xsl:with-param name="p_pb-start" select="2"/>
                                    <xsl:with-param name="p_pb-stop" select="$v_pb-start - 1"/>
                                </xsl:call-template>
                            </div>
                        </xsl:if>
                    </front>
                    <body>
                        <xsl:apply-templates select="descendant::html:table[@id = 'ContentPlaceHolder1_dlIndexs']/html:tr"/>
                    </body>
                </text>
            </TEI>
        </xsl:result-document>
        </xsl:if>
    </xsl:template>

    <xsl:template match="html:table[@id = 'ContentPlaceHolder1_dlIndexs']/html:tr">
        <xsl:variable name="v_pb" select="number(normalize-space(./html:td[position() = 6]))"/>
        <xsl:variable name="v_pb-following-article" select="number(normalize-space(following-sibling::html:tr[1]/html:td[position() = 6]))"/>
        <pb ed="print">
            <xsl:attribute name="n">
                <xsl:value-of select="$v_pb"/>
            </xsl:attribute>
            <xsl:attribute name="facs">
                <xsl:value-of select="concat('#', $v_id-facs, $v_pb)"/>
            </xsl:attribute>
        </pb>
        <div type="article">
            <xsl:attribute name="facs">
                <xsl:value-of select="concat('http://archive.sakhrit.co/', ./html:td[2]/html:a/@href)"/>
            </xsl:attribute>
            <head>
                <xsl:value-of select="normalize-space(./html:td[position() = 4])"/>
            </head>
            <!-- information on author -->
            <xsl:if test="normalize-space(./html:td[position() = 2]) != ''">
                <byline>
                    <persName>
                        <xsl:value-of select="normalize-space(./html:td[position() = 2])"/>
                    </persName>
                </byline>
            </xsl:if>
            <!-- generate intermittend pbs based on the table of content -->
            <xsl:if test="$v_pb-following-article > 0">
                <xsl:call-template name="t_generate-pb">
                    <xsl:with-param name="p_pb-start" select="$v_pb + 1"/>
                    <xsl:with-param name="p_pb-stop" select="$v_pb-following-article"/>
                </xsl:call-template>
            </xsl:if>
        </div>
    </xsl:template>

    <!-- generate pbs for intermittend pages -->
    <xsl:template name="t_generate-pb">
        <xsl:param name="p_pb-start"/>
        <xsl:param name="p_pb-stop"/>
        <pb ed="print">
            <xsl:attribute name="n">
                <xsl:value-of select="$p_pb-start"/>
            </xsl:attribute>
            <xsl:attribute name="facs">
                <xsl:value-of select="concat('#', $v_id-facs, $p_pb-start)"/>
            </xsl:attribute>
        </pb>
        <xsl:if test="$p_pb-start &lt; $p_pb-stop">
            <xsl:call-template name="t_generate-pb">
                <xsl:with-param name="p_pb-start" select="$p_pb-start + 1"/>
                <xsl:with-param name="p_pb-stop" select="$p_pb-stop"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- transform links to images to surface -->
    <xsl:template match="till:image">
        <xsl:element name="tei:surface">
            <xsl:attribute name="xml:id" select="concat($v_id-facs, @n)"/>
            <xsl:element name="tei:graphic">
                <xsl:attribute name="xml:id" select="concat($v_id-facs, @n, '-g_1')"/>
                <xsl:attribute name="url" select="child::till:url"/>
                <xsl:attribute name="mimeType" select="'image/jpg'"/>
            </xsl:element>
            <xsl:element name="tei:graphic">
                <xsl:attribute name="xml:id" select="concat($v_id-facs, @n, '-g_2')"/>
                <xsl:attribute name="url" select="concat('../images', child::till:urlLocal)"/>
                <xsl:attribute name="mimeType" select="'image/jpeg'"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>


</xsl:stylesheet>
