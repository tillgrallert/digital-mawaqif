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

        <!-- build the output -->
        <xsl:value-of
            select="'&lt;?xml-stylesheet type=&quot;text/xsl&quot; href=&quot;https://rawgit.com/tillgrallert/tei-boilerplate-arabic-editions/online-local-facsimiles/xslt-boilerplate/teibp.xsl&quot;?>'"
            disable-output-escaping="yes"/>
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title xml:lang="ar-Latn-x-ijmes">Mawāqif</title>
                    </titleStmt>
                    <publicationStmt>
                        <p>Publication Information</p>
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
                        </biblStruct>
                    </sourceDesc>
                </fileDesc>
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
                </front>
                <body>
                    <xsl:apply-templates select="descendant::html:table[@id = 'ContentPlaceHolder1_dlIndexs']/html:tr"/>
                </body>
            </text>
        </TEI>
    </xsl:template>

    <xsl:template match="html:table[@id = 'ContentPlaceHolder1_dlIndexs']/html:tr">
        <xsl:variable name="v_pb" select="number(normalize-space(./html:td[position() = 6]))"/>
        <xsl:variable name="v_pb-following-article" select="number(normalize-space(following-sibling::html:tr[1]/html:td[position() = 6]))"/>
        <pb ed="print">
            <xsl:attribute name="n">
                <xsl:value-of select="$v_pb"/>
            </xsl:attribute>
            <xsl:attribute name="facs">
                <xsl:value-of select="concat('#',$v_id-facs,$v_pb)"/>
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
            <xsl:if test="$v_pb-following-article &gt; 0">
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
                <xsl:value-of select="concat('#',$v_id-facs,$p_pb-start)"/>
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
            <xsl:attribute name="xml:id" select="concat($v_id-facs,@n)"/>
            <xsl:element name="tei:graphic">
                <xsl:attribute name="xml:id" select="concat($v_id-facs,@n,'-g_1')"/>
                <xsl:attribute name="url" select="child::till:url"/>
                <xsl:attribute name="mimeType" select="'image/jpg'"/>
            </xsl:element>
            <xsl:element name="tei:graphic">
                <xsl:attribute name="xml:id" select="concat($v_id-facs,@n,'-g_2')"/>
                <xsl:attribute name="url" select="concat('../images',child::till:urlLocal)"/>
                <xsl:attribute name="mimeType" select="'image/jpeg'"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>


</xsl:stylesheet>
