<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:METS="http://www.loc.gov/METS/"
  xmlns:PREMIS="http://www.loc.gov/standards/premis"
  >

  <!-- Global Variables -->
  <xsl:variable name="gHtId" select="/MBooksTop/MBooksGlobals/HtId"/>
  <xsl:variable name="gAccessUseHeader" select="/MBooksTop/MBooksGlobals/AccessUse/Header"/>
  <xsl:variable name="gAccessUseLink" select="/MBooksTop/MBooksGlobals/AccessUse/Link"/>
  <xsl:variable name="gAccessUseAuxLink" select="/MBooksTop/MBooksGlobals/AccessUse/AuxLink"/>
  <xsl:variable name="gAccessUseIcon" select="/MBooksTop/MBooksGlobals/AccessUse/Icon"/>
  <xsl:variable name="gAccessUseAuxIcon" select="/MBooksTop/MBooksGlobals/AccessUse/AuxIcon"/>
  <xsl:variable name="gHasOcr" select="/MBooksTop/MBooksGlobals/HasOcr"/>
  <xsl:variable name="gPodUrl" select="/MBooksTop/MBooksGlobals/Pod/Url"/>
  <xsl:variable name="gSkin" select="/MBooksTop/MBooksGlobals/Skin"/>
  <xsl:variable name="gSdrInst" select="/MBooksTop/MBooksGlobals/EnvSDRINST"/>
  <xsl:variable name="gRightsAttribute" select="/MBooksTop/MBooksGlobals/RightsAttribute"/>
  <xsl:variable name="gSourceAttribute" select="/MBooksTop/MBooksGlobals/SourceAttribute"/>
  <xsl:variable name="gMdpMetadata" select="/MBooksTop/METS:mets/METS:dmdSec[@ID='DMD1']/collection/record"/>
  <xsl:variable name="gItemFormat" select="/MBooksTop/MBooksGlobals/ItemFormat"/>
  <xsl:variable name="gHasMARCAuthor" select="$gMdpMetadata/datafield[@tag='100']/subfield or $gMdpMetadata/datafield[@tag='110']/subfield or $gMdpMetadata/datafield[@tag='111']/subfield"/>
  <xsl:variable name="gItemHandle" select="/MBooksTop/MBooksGlobals/ItemHandle"/>
  <xsl:variable name="gLoggedIn" select="/MBooksTop/MBooksGlobals/LoggedIn"/>
  <xsl:variable name="gHathiTrustAffiliate" select="/MBooksTop/MBooksGlobals/HathiTrustAffiliate"/>
  <xsl:variable name="gMichiganAffiliate" select="/MBooksTop/MBooksGlobals/MichiganAffiliate"/>
  <xsl:variable name="gIsInLibrary" select="/MBooksTop/MBooksGlobals/InLibrary/Status"/>
  <xsl:variable name="gCurrentQ1" select="/MBooksTop/MBooksGlobals/CurrentCgi/Param[@name='q1']"/>
  <xsl:variable name="gContactEmail" select="/MBooksTop/MBooksGlobals/ContactEmail"/>
  <xsl:variable name="gContactText" select="/MBooksTop/MBooksGlobals/ContactText"/>
  <xsl:variable name="gVersionLabel" select="/MBooksTop/MBooksGlobals/VersionLabel"/>
  <xsl:variable name="gCatalogRecordNo" select="/MBooksTop/METS:mets/METS:dmdSec[@ID='DMD1']/collection/record/controlfield[@tag='001']"/>
  <xsl:variable name="gTitleString" select="/MBooksTop/MBooksGlobals/VolumeTitle"/>
  <xsl:variable name="gVolumeTitleFragment">
    <xsl:choose>
      <xsl:when test="/MBooksTop/MBooksGlobals/VolCurrTitleFrag!=' '">
        <xsl:value-of select="concat(' ', /MBooksTop/MBooksGlobals/VolCurrTitleFrag, '.')"/>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="' '"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="gFullPdfAccess" select="/MBooksTop/MdpApp/AllowFullPDF"/>
  <xsl:variable name="gFullPdfAccessMessage" select="/MBooksTop/MdpApp/FullPDFAccessMessage"/>
  <xsl:variable name="gCollectionList" select="/MBooksTop/MdpApp/CollectionList"/>
  <xsl:variable name="gCollectionForm" select="/MBooksTop/MdpApp/AddToCollectionForm"/>

  <xsl:variable name="gUsingSearch" select="string(/MBooksTop/MBooksGlobals/CurrentCgi/Param[@name='page'] = 'search')"/>

  <xsl:variable name="gTitleTruncAmt">
    <xsl:choose>
      <xsl:when test="$gVolumeTitleFragment!=' '">
        <xsl:value-of select="'40'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'50'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="gTruncTitleString">
    <xsl:call-template name="GetMaybeTruncatedTitle">
      <xsl:with-param name="titleString" select="$gTitleString"/>
      <xsl:with-param name="titleFragment" select="$gVolumeTitleFragment"/>
      <xsl:with-param name="maxLength" select="$gTitleTruncAmt"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="gFullTitleString">
    <xsl:value-of select="concat($gTitleString, ', ', $gVolumeTitleFragment)"/>
  </xsl:variable>

  <!-- Navigation bar -->
  <xsl:template name="subnav_header">

    <div id="mdpItemBar">
      <div id="ItemBarContainer">
        <!-- Back to Search Results -->
        <xsl:if test="normalize-space(//SearchForm/SearchResultsLink)">
          <xsl:call-template name="BuildBackToResultsLink" />
        </xsl:if>

        <!-- Search -->
        <div id="mdpSearch" role="search">
          <xsl:call-template name="BuildSearchForm">
            <xsl:with-param name="pSearchForm" select="MdpApp/SearchForm"/>
          </xsl:call-template>
        </div>
      </div>
    </div>

  </xsl:template>

  <!-- Navigation bar -->
  <xsl:template name="subnav_headerXXX">

    <div id="mdpItemBar">
      <div id="ItemBarContainer">

        <!-- Title, Author (short) -->
        <xsl:call-template name="ItemMetadata"/>

        <!-- New Bookmark -->
        <xsl:call-template name="ItemBookmark"/>

        <!-- Search -->
        <div id="mdpSearch">
          <xsl:call-template name="BuildSearchForm">
            <xsl:with-param name="pSearchForm" select="MdpApp/SearchForm"/>
          </xsl:call-template>
        </div>

        <!-- add COinS -->
        <xsl:for-each select="$gMdpMetadata">
          <xsl:call-template name="marc2coins" />
        </xsl:for-each>

      </div>
    </div>

  </xsl:template>

  <!-- schema org: start -->
  <xsl:template name="BuildSchemaOrgTitle">
    <xsl:param name="title"/>

    <xsl:element name="span">  
    <xsl:attribute name="itemprop">name</xsl:attribute><xsl:value-of select="$title"/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="BuildSchemaOrgAuthor">

    <xsl:variable name="author">
      <xsl:call-template name="MetadataAuthorHelper"/>        
    </xsl:variable>

    <xsl:element name="span">  
    <xsl:attribute name="itemprop">author</xsl:attribute><xsl:value-of select="$author"/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="BuildSchemaOrgUrl">
    <xsl:element name="span">  
    <xsl:attribute name="itemprop">url</xsl:attribute><xsl:value-of select="$gItemHandle"/>
    </xsl:element>
  </xsl:template>
  <!-- schema org: end -->


  <!-- FOAF: primary topic -->
  <xsl:variable name="gFOAFPrimaryTopicId">
    <xsl:value-of select="concat('[_:', $gHtId, ']')"/>
  </xsl:variable>

  <!-- RDFa: link -->
  <xsl:template name="BuildRDFaLinkElement">
    <xsl:element name="link">
      <xsl:attribute name="about"><xsl:value-of select="$gFOAFPrimaryTopicId"/></xsl:attribute>
      <xsl:attribute name="rel">foaf:isPrimaryTopicOf</xsl:attribute>
      <xsl:attribute name="href"><xsl:value-of select="$gItemHandle"/></xsl:attribute>
    </xsl:element>
  </xsl:template>

  <!-- RDFa: hidden_title_string wrapped in content-less span -->
  <xsl:template name="BuildRDFaWrappedTitle">
    <xsl:param name="visible_title_string"/>
    <xsl:param name="hidden_title_string"/>

    <!-- visible -->
    <xsl:element name="span">
      <xsl:attribute name="about"><xsl:value-of select="$gFOAFPrimaryTopicId"/></xsl:attribute>
      <xsl:attribute name="property">dc:title</xsl:attribute>
      <xsl:attribute name="rel">dc:type</xsl:attribute>
      <xsl:attribute name="href">http://purl.org/dc/dcmitype/Text</xsl:attribute>
      <xsl:attribute name="content"><xsl:value-of select="$hidden_title_string"/></xsl:attribute>
      <xsl:value-of select="$visible_title_string"/>
    </xsl:element>
  </xsl:template>

  <!-- RDFa: author -->
  <xsl:template name="BuildRDFaWrappedAuthor">
    <xsl:param name="visible"/>

    <xsl:variable name="author">
      <xsl:call-template name="MetadataAuthorHelper"/>
    </xsl:variable>

    <!-- not ever visible -->
    <xsl:if test="$gItemFormat='BK'">
      <xsl:element name="span">
        <xsl:attribute name="property">cc:attributionName</xsl:attribute>
        <xsl:attribute name="rel">cc:attributionURL</xsl:attribute>
        <xsl:attribute name="href"><xsl:value-of select="$gItemHandle"/></xsl:attribute>
        <!--xsl:attribute name="content"--> <!-- So it will be seen by CC scraper -->
          <xsl:value-of select="$author"/>
        <!--/xsl:attribute-->
      </xsl:element>
    </xsl:if>

    <!-- maybe visible -->
    <xsl:element name="span">
      <xsl:attribute name="property">dc:creator</xsl:attribute>
      <xsl:attribute name="content">
        <xsl:value-of select="$author"/>
      </xsl:attribute>
      <xsl:if test="$visible = 'visible'">
        <xsl:value-of select="$author"/>
      </xsl:if>
    </xsl:element>

  </xsl:template>

  <!-- RDFa: published -->
  <xsl:template name="BuildRDFaWrappedPublished">
    <xsl:param name="visible"/>

    <xsl:variable name="published">
      <xsl:call-template name="MetadataPublishedHelper"/>
    </xsl:variable>

    <!-- not ever visible -->
    <xsl:if test="$gItemFormat='SE'">
      <xsl:element name="span">
        <xsl:attribute name="property">cc:attributionName</xsl:attribute>
        <xsl:attribute name="rel">cc:attributionURL</xsl:attribute>
        <xsl:attribute name="href"><xsl:value-of select="$gItemHandle"/></xsl:attribute>
        <xsl:attribute name="content">
          <xsl:value-of select="$published"/>
        </xsl:attribute>
      </xsl:element>
    </xsl:if>

    <!-- maybe visible -->
    <xsl:element name="span">
      <xsl:attribute name="property">dc:publisher</xsl:attribute>
      <xsl:attribute name="content">
        <xsl:value-of select="$published"/>
      </xsl:attribute>
      <xsl:if test="$visible = 'visible'">
        <xsl:value-of select="$published"/>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <!-- RDFa: license -->
  <xsl:template name="BuildRDFaCCLicenseMarkup">
    <xsl:variable name="access_use_header">
      <xsl:value-of select="$gAccessUseHeader"/><xsl:text>. </xsl:text>
    </xsl:variable>

    <!-- Link text to the default HT.org page -->
    <xsl:element name="a">
      <xsl:attribute name="target">
        <xsl:text>_blank</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="$gAccessUseLink"/>
      </xsl:attribute>
      <xsl:value-of select="$access_use_header"/>
    </xsl:element>

    <xsl:if test="$gItemFormat='BK' and $gAccessUseAuxLink!=''">
      <xsl:element name="a">
        <xsl:attribute name="href"><xsl:value-of select="$gAccessUseAuxLink"/></xsl:attribute>
        <xsl:attribute name="rel">license</xsl:attribute>
      </xsl:element>
    </xsl:if>

    <xsl:if test="$gAccessUseIcon != '' or ( $gAccessUseAuxLink != '' and $gAccessUseAuxIcon != '' )">
      <br /><br />
    </xsl:if>

    <!-- If there's a default icon, link it default HT.org page -->
    <xsl:if test="$gAccessUseIcon!=''">
      <xsl:element name="a">
        <xsl:attribute name="target">
          <xsl:text>_blank</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="href">
          <xsl:value-of select="$gAccessUseLink"/>
        </xsl:attribute>
        <xsl:element name="img">
          <xsl:attribute name="src">
            <xsl:value-of select="$gAccessUseIcon"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:element>
    </xsl:if>

    <!-- (CC): If there's an auxillary icon, link it using auxillary link -->
    <xsl:if test="$gAccessUseAuxLink!='' and $gAccessUseAuxIcon!=''">
      <xsl:element name="a">
        <xsl:attribute name="target">
          <xsl:text>_blank</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="href">
          <xsl:value-of select="$gAccessUseAuxLink"/>
        </xsl:attribute>
        <xsl:element name="img">
          <xsl:attribute name="src">
            <xsl:value-of select="$gAccessUseAuxIcon"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:element>
    </xsl:if>

  </xsl:template>

  <!-- METADATA: All journal links -->
  <xsl:template name="BuildAllJournalLinksPopup">

  </xsl:template>

  <!-- METADATA: author metadata helper -->
  <xsl:template name="MetadataAuthorHelper">
    <xsl:for-each select="$gMdpMetadata/datafield[@tag='100']">
      <xsl:if test="subfield[@code='a']">
        <xsl:value-of select="subfield[@code='a']"/>
      </xsl:if>
      <xsl:if test="subfield[@code='b']">
        <xsl:text>&#x20;</xsl:text>
        <xsl:value-of select="subfield[@code='b']"/>
      </xsl:if>
      <xsl:if test="subfield[@code='c']">
        <xsl:text>&#x20;</xsl:text>
        <xsl:value-of select="subfield[@code='c']"/>
      </xsl:if>
      <xsl:if test="subfield[@code='e']">
        <xsl:text>&#x20;</xsl:text>
        <xsl:value-of select="subfield[@code='e']"/>
      </xsl:if>
      <xsl:if test="subfield[@code='q']">
        <xsl:text>&#x20;</xsl:text>
        <xsl:value-of select="subfield[@code='q']"/>
      </xsl:if>
      <xsl:if test="subfield[@code='d']">
        <xsl:text>&#x20;</xsl:text>
        <xsl:value-of select="subfield[@code='d']"/>
      </xsl:if>
    </xsl:for-each>

    <xsl:for-each select="$gMdpMetadata/datafield[@tag='110']">
      <xsl:value-of select="subfield[@code='a']"/>
      <xsl:if test="subfield[@code='b']">
        <xsl:text>&#32;</xsl:text>
        <xsl:value-of select="subfield[@code='c']"/>
      </xsl:if>
    </xsl:for-each>

    <xsl:for-each select="$gMdpMetadata/datafield[@tag='111']">
      <xsl:value-of select="subfield[@code='a']"/>
    </xsl:for-each>

  </xsl:template>

  <!-- METADATA: published metadata helper -->
  <xsl:template name="MetadataPublishedHelper">
    <xsl:if test="$gMdpMetadata/datafield[@tag='260']/subfield[@code='a']">
      <xsl:value-of select="$gMdpMetadata/datafield[@tag='260']/subfield[@code='a']"/>
      &#x20;
    </xsl:if>
    <xsl:if test="$gMdpMetadata/datafield[@tag='260']/subfield[@code='b']">
      <xsl:value-of select="$gMdpMetadata/datafield[@tag='260']/subfield[@code='b']"/>
      &#x20;
    </xsl:if>
    <xsl:if test="$gMdpMetadata/datafield[@tag='260']/subfield[@code='c']">
      <xsl:value-of select="$gMdpMetadata/datafield[@tag='260']/subfield[@code='c']"/>
    </xsl:if>

  </xsl:template>

  <!-- METADATA: MDP-style metadata helper -->
  <xsl:template name="MdpMetadataHelper">
    <xsl:param name="ssd"/>
    <div id="mdpFlexible_1">

      <xsl:if test="$gHasMARCAuthor">
        <div class="mdpMetaDataRow">
          <div class="mdpMetaDataRegionHead">
            <xsl:text>Author&#xa0;</xsl:text>
          </div>
          <div class="mdpMetaText">
            <xsl:call-template name="BuildRDFaWrappedAuthor">
              <xsl:with-param name="visible" select="'visible'"/>
            </xsl:call-template>
          </div>
        </div>
      </xsl:if>

      <xsl:if test="$gMdpMetadata/datafield[@tag='250']/subfield">
        <div class="mdpMetaDataRow">
          <div class="mdpMetaDataRegionHead">
            <xsl:text>Edition&#xa0;</xsl:text>
          </div>
          <div class="mdpMetaText">
            <xsl:value-of select="$gMdpMetadata/datafield[@tag='250']/subfield"/>
          </div>
        </div>
      </xsl:if>

      <div class="mdpMetaDataRow">
        <div class="mdpMetaDataRegionHead">
          <xsl:text>Published&#xa0;</xsl:text>
        </div>
        <div class="mdpMetaText">
          <xsl:call-template name="BuildRDFaWrappedPublished">
            <xsl:with-param name="visible" select="'visible'"/>
          </xsl:call-template>
        </div>
      </div>

      <xsl:if test="$gMdpMetadata/datafield[@tag='300']/subfield">
        <div class="mdpMetaDataRow">
          <div class="mdpMetaDataRegionHead">
            <xsl:text>Description&#xa0;</xsl:text>
          </div>
          <div class="mdpMetaText">
            <xsl:value-of select="$gMdpMetadata/datafield[@tag='300']/subfield[@code='a']"/>
            &#x20;
            <xsl:value-of select="$gMdpMetadata/datafield[@tag='300']/subfield[@code='b']"/>
            &#x20;
            <xsl:value-of select="$gMdpMetadata/datafield[@tag='300']/subfield[@code='c']"/>
          </div>
        </div>
      </xsl:if>

      <div class="mdpMetaDataRow">
        <div class="mdpMetaDataRegionHead">
          <xsl:text>Rights&#xa0;</xsl:text>
        </div>
        <div class="mdpMetaText">
          <xsl:call-template name="BuildRDFaCCLicenseMarkup"/>
        </div>
      </div>

      <!-- allow SSD user to link from SSDviewer to pageturner if desired -->
      <xsl:choose>
        <xsl:when test="$ssd">
          <xsl:call-template name="PermanentURL">
            <xsl:with-param name="ssd" select="$ssd"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="PermanentURL"/>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>


  <xsl:template name="PermanentURL">
    <xsl:param name="ssd"/>
    <div class="mdpMetaDataRow">
      <div class="mdpMetaDataRegionHead">
        <xsl:text>Permanent URL&#xa0;</xsl:text>
      </div>
      <div class="mdpMetaText">
        <xsl:choose>
          <xsl:when test="$gItemHandle=''">
            <xsl:text>not available</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="$ssd = 'true'">
                <a>
                  <xsl:attribute name="href"><xsl:value-of select="$gItemHandle"/></xsl:attribute>
                  <xsl:value-of select="$gItemHandle"/>
                </a>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$gItemHandle"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </div>
  </xsl:template>


  <!-- METADATA: Short -->
  <xsl:template name="ItemMetadata">
    <div id="mdpItemMetadata">

      <xsl:element name="a">
        <xsl:attribute name="class">SkipLink</xsl:attribute>
        <xsl:attribute name="name">SkipToBookInfo</xsl:attribute>
      </xsl:element>

      <xsl:element name="h2">
        <xsl:attribute name="class">SkipLink</xsl:attribute>
        <xsl:text>Bibliographic Information about this book</xsl:text>
      </xsl:element>

      <div class="mdpMetaDataRow">
        <div class="mdpMetaDataRegionHead">
          <xsl:text>Title&#xa0;</xsl:text>
          <xsl:if test="/MBooksTop/MBooksGlobals/SSDSession='false'">
            <xsl:element name="a">
              <xsl:attribute name="id">mdpFlexible_1_1</xsl:attribute>
              <xsl:attribute name="href">
                <xsl:value-of select="'#'"/>
              </xsl:attribute>
              <xsl:attribute name="onclick">
                <xsl:value-of select="'javascript:ToggleCitationSize();'"/>
                <xsl:if test="$gGoogleOnclickTracking = 'true'">
                  <xsl:call-template name="PageTracker">
                  <xsl:with-param name="label" select="'PT morelink'"/>
                </xsl:call-template>
                </xsl:if>
              </xsl:attribute>
              <xsl:attribute name="onkeypress">
                <xsl:value-of select="'javascript:ToggleCitationSize();'"/>
              </xsl:attribute>
              <xsl:text>more &#x00BB;</xsl:text>

            </xsl:element>
          </xsl:if>
        </div>

      <!-- Title -->
        <div class="mdpMetaText">
          <xsl:call-template name="BuildRDFaWrappedTitle">
            <xsl:with-param name="visible_title_string" select="$gTruncTitleString"/>
            <xsl:with-param name="hidden_title_string" select="$gFullTitleString"/>
          </xsl:call-template>
        </div>

       <div itemscope="" itemtype="http://schema.org/Book" style="display:none">
          <meta itemprop="accessibilityFeature" content="alternativeText"/>
          <meta itemprop="accessibilityFeature" content="bookmarks"/>
          <meta itemprop="accessibilityFeature" content="index"/>
          <meta itemprop="accessibilityFeature" content="longDescription"/>
          <meta itemprop="accessibilityFeature" content="readingOrder"/>
          <meta itemprop="accessibilityAPI"     content="ARIA"/>
          <meta itemprop="accessibilityControl" content="fullKeyboardControl"/>
          <meta itemprop="accessibilityControl" content="fullMouseControl"/>
          <xsl:call-template name="BuildSchemaOrgTitle">
            <xsl:with-param name="title" select="$gFullTitleString"/>
          </xsl:call-template>
          <xsl:call-template name="BuildSchemaOrgAuthor"/>
          <xsl:call-template name="BuildSchemaOrgUrl"/>
        </div>

      </div>

      <!-- Author, Edition, Published, Description -->
      <xsl:call-template name="MdpMetadataHelper"/>
    </div>

  </xsl:template>

  <!-- Link to OCLC Get Book -->
  <xsl:template name="FindInALibraryLink">
    <xsl:for-each select="$gMdpMetadata/datafield[@tag='035'][contains(.,'OCoLC)ocm') or contains(.,'OCoLC') or contains(.,'oclc') or contains(.,'ocm') or contains(.,'ocn')][1]">
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:text>http://www.worldcat.org/oclc/</xsl:text>
          <xsl:choose>
            <xsl:when test="contains(.,'OCoLC)ocm')">
              <xsl:value-of select="substring-after(.,'OCoLC)ocm')"/>
            </xsl:when>
            <xsl:when test="contains(.,'OCoLC')">
              <xsl:value-of select="substring-after(.,'OCoLC)')"/>
            </xsl:when>
            <xsl:when test="contains(.,'oclc')">
              <xsl:value-of select="substring-after(.,'oclc')"/>
            </xsl:when>
            <xsl:when test="contains(.,'ocm')">
              <xsl:value-of select="substring-after(.,'ocm')"/>
            </xsl:when>
            <xsl:when test="contains(.,'ocn')">
              <xsl:value-of select="substring-after(.,'ocn')"/>
            </xsl:when>
            <xsl:otherwise/>
          </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="title">Link to OCLC Find in a Library</xsl:attribute>

        <xsl:if test="$gGoogleOnclickTracking = 'true'">
          <xsl:attribute name="onclick">
            <xsl:call-template name="PageTracker">
              <xsl:with-param name="category" select="'outLinks'"/>
              <xsl:with-param name="action" select="'click'"/>
              <xsl:with-param name="label" select="'PT Find in a Library'"/>
            </xsl:call-template>
          </xsl:attribute>
        </xsl:if>

        <xsl:text>Find in a library »</xsl:text>

      </xsl:element>
    </xsl:for-each>

  </xsl:template>



  <!-- New Bookmark -->
  <xsl:template name="ItemBookmark">
    <div class="mdpBookmark">
      <xsl:choose>
        <xsl:when test="$gItemHandle=''">
          <xsl:text>not available</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <!-- The javascript function call uses double-quoted
               parameters but the title may have double quotes in it so
               escape those -->
          <xsl:variable name="safeBookmarkTitle">
            <xsl:call-template name="ReplaceChar">
              <xsl:with-param name="string">
                <xsl:value-of select="$gTruncTitleString"/>
              </xsl:with-param>
              <xsl:with-param name="from_char">
                <xsl:text>"</xsl:text>
              </xsl:with-param>
              <xsl:with-param name="to_char">
                <xsl:text>\"</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:variable>

          <!-- -->
          <xsl:variable name="parameters">
            <xsl:value-of select="concat('&quot;', $safeBookmarkTitle, '&quot;', ',', '&quot;', $gItemHandle, '&quot;')"/>
          </xsl:variable>

          <!-- -->
          <xsl:variable name="theJS" select="concat('javascript:Bookmark(', $parameters, ');'  )"/>
          <xsl:element name="a">
            <xsl:attribute name="id">mdpBookmarkIcon</xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of select="'#'"/>
            </xsl:attribute>
            <xsl:attribute name="onclick">
              <xsl:value-of select="$theJS"/>
              <xsl:if test="$gGoogleOnclickTracking = 'true'">
                  <xsl:call-template name="PageTracker">
                  <xsl:with-param name="label" select="'PT bookmark'"/>
                </xsl:call-template>
            </xsl:if>

            </xsl:attribute>
            <xsl:attribute name="onkeypress">
              <xsl:value-of select="$theJS"/>
              <xsl:if test="$gGoogleOnclickTracking = 'true'">
                  <xsl:call-template name="PageTracker">
                  <xsl:with-param name="label" select="'PT bookmark'"/>
                </xsl:call-template>
            </xsl:if>

            </xsl:attribute>

            <xsl:element name="img">
              <xsl:attribute name="src">//common-web/graphics/bookmark.gif</xsl:attribute>
              <xsl:attribute name="alt">Bookmark this item</xsl:attribute>
              <xsl:attribute name="title">Bookmark this item in your browser</xsl:attribute>
            </xsl:element>
          </xsl:element>
          <xsl:element name="a">
            <xsl:attribute name="id">mdpBookmarkLink2</xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of select="'#'"/>
            </xsl:attribute>
            <xsl:attribute name="onclick">
              <xsl:value-of select="$theJS"/>
              <xsl:if test="$gGoogleOnclickTracking = 'true'">
                <xsl:call-template name="PageTracker">
                  <xsl:with-param name="label" select="'PT bookmark'"/>
                </xsl:call-template>
              </xsl:if>
          </xsl:attribute>

            <xsl:attribute name="onkeypress">
              <xsl:value-of select="$theJS"/>
              <xsl:if test="$gGoogleOnclickTracking = 'true'">
                <xsl:call-template name="PageTracker">
                  <xsl:with-param name="label" select="'PT bookmark'"/>
                </xsl:call-template>
              </xsl:if>
            </xsl:attribute>
            <xsl:text>bookmark</xsl:text>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </div>

  </xsl:template>


  <!-- FORM: Search -->
  <xsl:template name="BuildSearchForm">
    <xsl:param name="pSearchForm"/>
    <xsl:param name="pShowLabel" select="'YES'"/>

    <xsl:element name="form">
      <xsl:attribute name="onsubmit">
        <xsl:value-of select="'return FormValidation(this.q1, &quot;Please enter a term in the search box.&quot;)'"/>
      </xsl:attribute>
      <xsl:attribute name="method">get</xsl:attribute>
      <xsl:attribute name="action">
        <xsl:choose>
          <xsl:when test="$gUsingSearch = 'true'">
            <xsl:text>search</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>pt/search</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <ul class="searchForm">
        <xsl:if test="$pShowLabel='YES'">
          <li id="mdpSearchFormLabel">
            <h2 id="SkipToSearch" tabindex="0">
              <label for="mdpSearchInputBox">
                <xsl:text>Search in this text</xsl:text>
              </label>
            </h2>
          </li>
        </xsl:if>

        <li class="asearchform">
          <xsl:apply-templates select="$pSearchForm/HiddenVars"/>
          <xsl:element name="input">
            <xsl:attribute name="type">hidden</xsl:attribute>
            <xsl:attribute name="name">view</xsl:attribute>
            <xsl:attribute name="value"><xsl:value-of select="/MBooksTop/MBooksGlobals/CurrentCgi/Param[@name='view']" /></xsl:attribute>
          </xsl:element>
          <xsl:if test="/MBooksTop/MBooksGlobals/CurrentCgi/Param[@name='seq']">
            <xsl:element name="input">
              <xsl:attribute name="type">hidden</xsl:attribute>
              <xsl:attribute name="name">seq</xsl:attribute>
              <xsl:attribute name="value"><xsl:value-of select="/MBooksTop/MBooksGlobals/CurrentCgi/Param[@name='seq']" /></xsl:attribute>
            </xsl:element>
          </xsl:if>
          <xsl:if test="/MBooksTop/MBooksGlobals/CurrentCgi/Param[@name='num']">
            <xsl:element name="input">
              <xsl:attribute name="type">hidden</xsl:attribute>
              <xsl:attribute name="name">num</xsl:attribute>
              <xsl:attribute name="value"><xsl:value-of select="/MBooksTop/MBooksGlobals/CurrentCgi/Param[@name='num']" /></xsl:attribute>
            </xsl:element>
          </xsl:if>

          <xsl:element name="input">
            <xsl:attribute name="id">mdpSearchInputBox</xsl:attribute>
            <xsl:attribute name="type">text</xsl:attribute>
            <xsl:attribute name="name">q1</xsl:attribute>
            <xsl:attribute name="maxlength">150</xsl:attribute>
            <xsl:attribute name="size">30</xsl:attribute>
            <xsl:if test="$gHasOcr!='YES'">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$gHasOcr='YES'">
                <xsl:attribute name="value">
                  <xsl:value-of select="$gCurrentQ1"/>
                </xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="value">
                  <xsl:value-of select="'No text to search in this item'"/>
                </xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
          <xsl:if test="$gHasOcr='YES'">
            <xsl:element name="input">
              <xsl:attribute name="id">mdpSearchButton</xsl:attribute>
              <xsl:attribute name="type">submit</xsl:attribute>
              <xsl:attribute name="value">Search</xsl:attribute>
            </xsl:element>
          </xsl:if>
        </li>
      </ul>
      <xsl:call-template name="HiddenDebug"/>
    </xsl:element>

  </xsl:template>


  <!-- Feedback -->
  <xsl:template name="Feedback">

    <xsl:element name="h2">
      <xsl:attribute name="class">SkipLink</xsl:attribute>
      <xsl:text>Send feedback about this book</xsl:text>
    </xsl:element>

    <xsl:call-template name="BuildFeedbackForm"/>

  </xsl:template>


  <!-- FORM: Page Image Feedback -->
  <xsl:template name="BuildFeedbackForm">
    <div id="mdpFeedbackForm">
      <xsl:element name="form">
        <xsl:attribute name="method">
          <xsl:choose>
            <xsl:when test="/MBooksTop/MBooksGlobals/CurrentCgi/Param[@name='debug']">
              <xsl:text>get</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>post</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="id">mdpFBform</xsl:attribute>
        <xsl:attribute name="name">mdpFBform</xsl:attribute>

        <xsl:attribute name="action">
          <!-- Coupled to $gFeedbackCGIUrl in mdpglobals.cfg -->
          <xsl:value-of select="/MBooksTop/MdpApp/FeedbackForm/FeedbackCGIUrl"/>
        </xsl:attribute>

        <div>
          <!-- hidden vars -->
          <xsl:element name="input">
            <xsl:attribute name="type">hidden</xsl:attribute>
            <xsl:attribute name="name">SysID</xsl:attribute>
            <xsl:attribute name="value">
              <xsl:value-of select="/MBooksTop/MBooksGlobals/CurrentCgi/Param[@name='id']"/>
            </xsl:attribute>
          </xsl:element>

          <xsl:element name="input">
            <xsl:attribute name="type">hidden</xsl:attribute>
            <xsl:attribute name="name">RecordURL</xsl:attribute>
            <xsl:attribute name="value">
              <xsl:text>http://catalog.hathitrust.org/Record/</xsl:text>
              <xsl:value-of select="$gCatalogRecordNo"/>
            </xsl:attribute>
          </xsl:element>

          <xsl:element name="input">
            <xsl:attribute name="type">hidden</xsl:attribute>
            <xsl:attribute name="name">return</xsl:attribute>
            <xsl:attribute name="value">
              <xsl:value-of select="/MBooksTop/MBooksGlobals/CurrentUrl"/>
            </xsl:attribute>
          </xsl:element>

          <xsl:element name="input">
            <xsl:attribute name="type">hidden</xsl:attribute>
            <xsl:attribute name="name">m</xsl:attribute>
            <xsl:attribute name="value">pt</xsl:attribute>
          </xsl:element>


          <xsl:element name="input">
            <xsl:attribute name="type">hidden</xsl:attribute>
            <xsl:attribute name="name">SeqNo</xsl:attribute>
            <xsl:attribute name="value">
              <xsl:value-of select="/MBooksTop/MBooksGlobals/CurrentCgi/Param[@name='seq']"/>
            </xsl:attribute>
          </xsl:element>

          <xsl:element name="input">
            <xsl:attribute name="type">hidden</xsl:attribute>
            <xsl:attribute name="name">view</xsl:attribute>
            <xsl:attribute name="value">
              <xsl:value-of select="/MBooksTop/MBooksGlobals/CurrentCgi/Param[@name='view']"/>
            </xsl:attribute>
          </xsl:element>

          <xsl:call-template name="HiddenDebug"/>
        </div>

        <fieldset class="mdpFbSubtitle">
          <legend>
            <xsl:text>Overall page readability and quality</xsl:text>
          </legend>

          <div id="mdpFlexible_2_Qual">
            <div class="mdpFbSubSubtitle">
              <input name="Quality" type="radio" value="readable" id="readable" />
              <label for="readable">Few problems, entire page is readable</label>
            </div>
            <div class="mdpFbSubSubtitle">
              <input name="Quality" type="radio" value="someproblems" id="someproblems" />
              <label for="someproblems">Some problems, but still readable</label>
            </div>
            <div class="mdpFbSubSubtitle">
              <input name="Quality" type="radio" value="difficult" id="difficult" />
              <label for="difficult">Significant problems, difficult or impossible to read</label>
            </div>
          </div>
        </fieldset>

        <fieldset class="mdpFbSubtitle">
          <legend>
            <xsl:text>Specific page image problems?</xsl:text>
          </legend>
          <div id="mdpFlexible_2_Spec">
            <div class="mdpFbSubSubtitle">
              <input type="checkbox" name="missing" value="1" id="missing" />
              <label for="missing">Missing parts of the page</label>
            </div>
            <div class="mdpFbSubSubtitle">
              <input type="checkbox" name="blurry" value="1" id="blurry" />
              <label for="blurry">Blurry text</label>
            </div>
            <div class="mdpFbSubSubtitle">
              <input type="checkbox" name="curved" value="1" id="curved" />
              <label for="curved">Curved or distorted text</label>
            </div>
            <div class="mdpFbSubSubtitle">
              <!-- pfarber: lose the checkbox beside the text field -->
              <!-- input type="checkbox" name="other" value="1" id="other" alt="Other problem"/-->
              <!-- see: $FBGlobals::gOtherDescLimit -->
              <label for="other">Other problem</label>
              <input id="other" name="other" value="" class="overlay" maxlength="50" />
            </div>
          </div>
        </fieldset>

        <fieldset class="mdpFbSubtitle">
          <legend>
            <xsl:text>Problem with access rights? </xsl:text>
          </legend>
          <p>(See also: <a href="http://www.hathitrust.org/take_down_policy"
          target="_blank">take-down policy</a>)</p>
          <div id="mdpFlexible_2_Rights">
            <div class="mdpFbSubSubtitle">
              <input name="Rights" type="radio" value="noaccess" id="noaccess" />
              <label for="noaccess">This item is in the public domain, but I don't have access to it.</label>
            </div>
            <div class="mdpFbSubSubtitle">
              <input name="Rights" type="radio" value="access" id="access" />
              <label for="access">I have access to this item, but should not.</label>
            </div>
          </div>
        </fieldset>

        <div class="mdpFbSubtitle">
          <label for="comments">Other problems or comments?</label>
        </div>
        <div id="mdpFlexible_2_Other">
          <div>
            <!-- see: $FBGlobals::gCommentsLimit -->
            <textarea name="comments" id="comments" class="overlay" rows="2" cols="40"/>
          </div>
        </div>

        <div>
          <div id="mdpEmail">
            <label id="mdpEmailLabel" for="email">To request a reply, enter your email address below. (We will make every effort to address copyright issues by the next business
            day after notification.)</label>
            <span><input id="email" name="email" class="overlay" value="[Your email address]" maxlength="50" size="50" onclick="ClickClear(this, '[Your email address]')" onkeypress="ClickClear(this, '[Your email address]')"/></span>
          </div>
        </div>

        <div id="emptyFBError" aria-live="assertive" aria-atomic="true">
        </div>

        <div id="mdpFBtools" class="cf">
          <div class="mdpFBbuttons">
            <input id="mdpFBinputbutton" type="submit" name="submit" value="Submit" />
            <a id='mdpFBcancel' href=''><strong>Cancel</strong></a>
          </div>
        </div>
 
      </xsl:element>

    </div>
  </xsl:template>

  <!-- HARMONY: SIDEBAR -->
  <xsl:template name="aboutThisBook">

        <div itemscope="" itemtype="http://schema.org/Book" style="display:none">
          <meta itemprop="accessibilityFeature" content="alternativeText"/>
          <meta itemprop="accessibilityFeature" content="bookmarks"/>
          <meta itemprop="accessibilityFeature" content="index"/>
          <meta itemprop="accessibilityFeature" content="longDescription"/>
          <meta itemprop="accessibilityFeature" content="readingOrder"/>
          <meta itemprop="accessibilityAPI"     content="ARIA"/>
          <meta itemprop="accessibilityControl" content="fullKeyboardControl"/>
          <meta itemprop="accessibilityControl" content="fullMouseControl"/>
          <xsl:call-template name="BuildSchemaOrgTitle">
            <xsl:with-param name="title" select="$gFullTitleString"/>
          </xsl:call-template>
          <xsl:call-template name="BuildSchemaOrgAuthor"/>
          <xsl:call-template name="BuildSchemaOrgUrl"/>
        </div>

    <div class="bibLinks">
      <h2>About this Book</h2>
      <h3 class="offscreen">Catalog Record Details</h3>
      <p>
        <xsl:call-template name="BuildRDFaWrappedTitle">
          <xsl:with-param name="visible_title_string" select="$gTruncTitleString"/>
          <xsl:with-param name="hidden_title_string" select="$gFullTitleString"/>
        </xsl:call-template>
        <!-- set author off from title with a space -->
        <xsl:value-of select="' '"/>

        <!-- not visible -->
        <xsl:call-template name="BuildRDFaWrappedAuthor"/>
        <!-- not visible -->
        <xsl:call-template name="BuildRDFaWrappedPublished"/>
      </p>
      <p>
        <xsl:variable name="record_no">
          <xsl:value-of select="$gCatalogRecordNo"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$record_no!=''">
            <xsl:element name="a">
              <xsl:variable name="href">
                <xsl:text>http://catalog.hathitrust.org/Record/</xsl:text>
                <xsl:value-of select="$record_no"/>
              </xsl:variable>
              <xsl:attribute name="class">tracked</xsl:attribute>
              <xsl:attribute name="data-tracking-category">outLinks</xsl:attribute>
              <xsl:attribute name="data-tracking-action">PT VuFind Catalog Record</xsl:attribute>
              <xsl:attribute name="data-tracking-label"><xsl:value-of select="$href" /></xsl:attribute>
              <xsl:attribute name="href"><xsl:value-of select="$href" /></xsl:attribute>
              <xsl:attribute name="title">Link to the HathiTrust VuFind Record for this item</xsl:attribute>
              <xsl:text>View full catalog record</xsl:text>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>Catalog record not available</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </p>
      <p class="smaller">
        <!-- Access &amp; Use:
        <xsl:element name="a">
          <xsl:attribute name="class">tracked</xsl:attribute>
          <xsl:attribute name="data-tracking-category">outLinks</xsl:attribute>
          <xsl:attribute name="data-tracking-action">PT Access Use Link</xsl:attribute>
          <xsl:attribute name="data-tracking-label"><xsl:value-of select="$gAccessUseLink" /></xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="$gAccessUseLink"/>
          </xsl:attribute>
          <xsl:value-of select="$gAccessUseHeader" />
        </xsl:element> -->
        <strong>Rights: </strong><xsl:call-template name="BuildRDFaCCLicenseMarkup" />
      </p>
    </div>
  </xsl:template>

  <xsl:template name="getThisBook">
    <xsl:param name="pViewTypeList" select="//MdpApp/ViewTypeLinks"/>

    <div class="getLinks">
      <h3>Get this Book</h3>
      <ul>
        <li>
          <xsl:for-each select="$gMdpMetadata/collection/record/datafield[@tag='035'][contains(.,'OCoLC)ocm') or contains(.,'OCoLC') or contains(.,'oclc') or contains(.,'ocm') or contains(.,'ocn')][1]">
            <xsl:element name="a">
              <xsl:attribute name="class">tracked</xsl:attribute>
              <xsl:attribute name="data-tracking-category">outLinks</xsl:attribute>
              <xsl:attribute name="data-tracking-action">PT Find in a Library</xsl:attribute>
              <xsl:attribute name="href">
                <xsl:text>http://www.worldcat.org/oclc/</xsl:text>
                  <xsl:choose>
                    <xsl:when test="contains(.,'OCoLC)ocm')">
                      <xsl:value-of select="substring-after(.,'OCoLC)ocm')"/>
                    </xsl:when>
                    <xsl:when test="contains(.,'OCoLC')">
                      <xsl:value-of select="substring-after(.,'OCoLC)')"/>
                    </xsl:when>
                    <xsl:when test="contains(.,'oclc')">
                      <xsl:value-of select="substring-after(.,'oclc')"/>
                    </xsl:when>
                    <xsl:when test="contains(.,'ocm')">
                      <xsl:value-of select="substring-after(.,'ocm')"/>
                    </xsl:when>
                    <xsl:when test="contains(.,'ocn')">
                      <xsl:value-of select="substring-after(.,'ocn')"/>
                    </xsl:when>
                    <xsl:otherwise/>
                  </xsl:choose>
              </xsl:attribute>
              <xsl:attribute name="title">Link to OCLC Find in a Library</xsl:attribute>
              <!-- <xsl:if test="$gGoogleOnclickTracking = 'true'">
                <xsl:attribute name="onclick">
                <xsl:call-template name="PageTracker">
                  <xsl:with-param name="category" select="'outLinks'"/>
                  <xsl:with-param name="action" select="'click'"/>
                  <xsl:with-param name="label" select="'PT Find in a Library'"/>
                </xsl:call-template>
                </xsl:attribute>
              </xsl:if> -->
              <xsl:text>Find in a library</xsl:text>
            </xsl:element>
          </xsl:for-each>
        </li>

        <xsl:if test="$gPodUrl != ''">
          <li>
            <xsl:element name="a">
              <xsl:attribute name="class">tracked</xsl:attribute>
              <xsl:attribute name="data-tracking-category">outLinks</xsl:attribute>
              <xsl:attribute name="data-tracking-action">PT Buy a copy</xsl:attribute>
              <xsl:attribute name="href">
                <xsl:value-of select="$gPodUrl"/>
              </xsl:attribute>
              <!-- <xsl:if test="$gGoogleOnclickTracking = 'true'">
                <xsl:attribute name="onclick">
                  <xsl:call-template name="PageTracker">
                    <xsl:with-param name="category" select="'outLinks'"/>
                    <xsl:with-param name="action" select="'click'"/>
                    <xsl:with-param name="label" select="'PT Buy a reprint'"/>
                  </xsl:call-template>
                </xsl:attribute>
              </xsl:if> -->
              <xsl:text>Buy a copy</xsl:text>
            </xsl:element>
          </li>
        </xsl:if>

        <xsl:if test="$gFinalAccessStatus = 'allow' and $gUsingSearch = 'false'">
        <li>
          <xsl:element name="a">
            <xsl:attribute name="title">Download this page (PDF)</xsl:attribute>
            <xsl:attribute name="id">pagePdfLink</xsl:attribute>
            <xsl:attribute name="class">tracked</xsl:attribute>
            <xsl:attribute name="data-tracking-category">PT</xsl:attribute>
            <xsl:attribute name="data-tracking-action">PT Download PDF - this page</xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of select="$pViewTypeList/ViewTypePdfLink"/>
            </xsl:attribute>
            <xsl:attribute name="target">
              <xsl:text>pdf</xsl:text>
            </xsl:attribute>
            <xsl:text>Download this page (PDF)</xsl:text>
          </xsl:element>
        </li>
        </xsl:if>

        <xsl:if test="$gFullPdfAccessMessage='' or $gFullPdfAccessMessage='NOT_AFFILIATED' or $gFullPdfAccessMessage='RESTRICTED_SOURCE'">
          <li>
            <xsl:choose>
              <xsl:when test="$gFullPdfAccessMessage='RESTRICTED_SOURCE'">
                <xsl:text>Download whole book (PDF)</xsl:text>
                <br />
                <i>Not available</i> (<a href="http://www.hathitrust.org/help_digital_library#FullPDF" target="_blank">why not?</a>)
              </xsl:when>
              <xsl:otherwise>
                <xsl:element name="a">
                  <xsl:attribute name="title">Download whole book (PDF)</xsl:attribute>
                  <xsl:attribute name="id">fullPdfLink</xsl:attribute>
                  <xsl:attribute name="class">tracked</xsl:attribute>
                  <xsl:attribute name="data-tracking-category">PT</xsl:attribute>
                  <xsl:attribute name="data-tracking-action">PT Download PDF - whole book</xsl:attribute>
                  <xsl:attribute name="rel"><xsl:value-of select="$gFullPdfAccess" /></xsl:attribute>
                  <xsl:attribute name="href">
                    <xsl:value-of select="$pViewTypeList/ViewTypeFullPdfLink"/>
                  </xsl:attribute>
                  <xsl:text>Download whole book (PDF)</xsl:text>
                </xsl:element>
                <xsl:if test="$gFullPdfAccessMessage = 'NOT_AFFILIATED'">
                  <p class="pdfPartnerLoginLinkMessage">Partner login required</p>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>

            <xsl:if test="$gFullPdfAccess = 'deny'">
              <div id="noPdfAccess">
                <p style="text-align: left">
                  <xsl:choose>
                    <xsl:when test="$gLoggedIn = 'NO' and $gFullPdfAccessMessage = 'NOT_AFFILIATED'">
                      <xsl:text>Partner institution members: </xsl:text>
                      <strong><a href="{$pViewTypeList/ViewTypeFullPdfLink}">Login</a></strong>
                      <xsl:text> to download this book.</xsl:text>
                      <br />
                      <br />
                      <em>If you are not a member of a partner institution,
                        <br />
                        whole book download is not available.
                        (<a href="http://www.hathitrust.org/help_digital_library#Download" target="_blank">why not?</a>)</em>
                    </xsl:when>
                    <xsl:when test="$gFullPdfAccessMessage = 'NOT_AFFILIATED'">
                      <xsl:text>Full PDF available only to authenticated users from </xsl:text>
                      <a href="http://www.hathitrust.org/help_digital_library#LoginNotListed" target="_blank">HathiTrust partner institutions.</a>
                    </xsl:when>
                    <xsl:when test="$gFullPdfAccessMessage = 'NOT_PD'">
                      <xsl:text>In-copyright books cannot be downloaded.</xsl:text>
                    </xsl:when>
                    <xsl:when test="$gFullPdfAccessMessage = 'NOT_AVAILABLE'">
                      <xsl:text>This book cannot be downloaded.</xsl:text>
                    </xsl:when>
                    <xsl:when test="$gFullPdfAccessMessage = 'RESTRICTED_SOURCE'">
                      <xsl:comment>Handled above</xsl:comment>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>Sorry.</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </p>
              </div>
            </xsl:if>
            <div id="fullPdfFrame"></div>
          </li>
        </xsl:if>
     </ul>
    </div>
  </xsl:template>

  <xsl:template name="addToCollection">
    <div class="collectionLinks">
      <h3>Add to Collection</h3>
      <xsl:call-template name="CollectionWidgetContainer" />
    </div>
  </xsl:template>

  <xsl:template name="shareThisBook">
    <div class="shareLinks">
      <h3>Share</h3>
      <form action="" name="urlForm" id="urlForm">
        <label class="smaller" for="permURL">Permanent link to this book</label>
        <!-- <input type="text" name="permURL_link" id="permURL" class="email-permURL" onclick="document.urlForm.permURL_link.select();" readonly="readonly = true;" value="http://hdl.handle.net/2027/mdp.39015015394847" /> -->
        <xsl:element name="input">
          <xsl:attribute name="type">text</xsl:attribute>
          <xsl:attribute name="name">permURL_link</xsl:attribute>
          <xsl:attribute name="id">permURL</xsl:attribute>
          <xsl:attribute name="class">email-permURL</xsl:attribute>
          <xsl:attribute name="onclick">document.urlForm.permURL_link.select();</xsl:attribute>
          <xsl:attribute name="class">tracked</xsl:attribute>
          <xsl:attribute name="data-tracking-category">PT</xsl:attribute>
          <xsl:attribute name="data-tracking-action">PT Link to this Book</xsl:attribute>
          <xsl:attribute name="data-tracking-label"><xsl:value-of select="$gItemHandle" /></xsl:attribute>
          <xsl:attribute name="readonly">readonly</xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="$gItemHandle"/>
          </xsl:attribute>
        </xsl:element>

        <xsl:if test="$gUsingSearch = 'false'">
        <br />

        <label class="smaller" for="pageURL">Link to this page</label>
        <xsl:variable name="pageLink">
          <xsl:value-of select="$gItemHandle" />
          <xsl:text>?urlappend=%3Bseq=</xsl:text>
          <xsl:value-of select="/MBooksTop/MBooksGlobals/CurrentCgi/Param[@name='seq']"/>
        </xsl:variable>

        <xsl:element name="input">
          <xsl:attribute name="type">text</xsl:attribute>
          <xsl:attribute name="name">pageURL_link</xsl:attribute>
          <xsl:attribute name="id">pageURL</xsl:attribute>
          <xsl:attribute name="class">email-permURL</xsl:attribute>
          <xsl:attribute name="onclick">document.urlForm.pageURL_link.select();</xsl:attribute>
          <xsl:attribute name="class">tracked</xsl:attribute>
          <xsl:attribute name="data-tracking-category">PT</xsl:attribute>
          <xsl:attribute name="data-tracking-action">PT Link to this Page</xsl:attribute>
          <xsl:attribute name="readonly">readonly</xsl:attribute>
          <xsl:attribute name="data-tracking-label"><xsl:value-of select="$pageLink" /></xsl:attribute>
          <xsl:attribute name="value"><xsl:value-of select="$pageLink" /></xsl:attribute>
        </xsl:element>

        </xsl:if>

      </form>
    </div>
  </xsl:template>

  <!-- -->
  <xsl:template name="versionLabel">
    <div class="versionContainer">
      <strong>Version: </strong><xsl:value-of select="$gVersionLabel"/>
      <xsl:element name="a">
        <xsl:attribute name="id">versionIcon</xsl:attribute>
        <xsl:attribute name="href">
          <xsl:value-of select="' '"/>
        </xsl:attribute>
        <xsl:text>version label for this item</xsl:text>
      </xsl:element>
    </div>
  </xsl:template>

  <!-- Collection Widget -->
  <xsl:template name="CollectionWidgetContainer">

    <div id="PTcollection">
      <xsl:variable name="collection_list_label">
        <xsl:choose>
          <xsl:when test="$gLoggedIn='YES'">
            <xsl:choose>
              <xsl:when test="$gCollectionList/Coll">
                <h3 class="SkipLink">Collections with this Item</h3>
                <xsl:text>This item is in your collection(s):</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>This item is not in any of your collections</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="a">
              <xsl:attribute name="class">PTloginLinkText</xsl:attribute>
              <xsl:attribute name="href">
                <xsl:value-of select="/MBooksTop/MdpApp/LoginLink"/>
              </xsl:attribute>
              <xsl:text>Login</xsl:text>
            </xsl:element>
            <xsl:text> to make your personal collections permanent</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <span id="PTitemInCollLabel" class="PTcollectionlabel">
        <xsl:copy-of select="$collection_list_label"/>
      </span>

      <ul id="PTcollectionList">
        <xsl:choose>
          <xsl:when test="$gCollectionList/Coll">
            <xsl:for-each select="$gCollectionList/Coll">
              <li>
                <xsl:element name="a">
                  <xsl:attribute name="href">
                    <xsl:value-of select="Url"/>
                  </xsl:attribute>
                  <xsl:value-of select="CollName"/>
                </xsl:element>
              </li>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
      </ul>

      <h4 class="offscreen">Add Item to Collection</h4>

      <xsl:call-template name="BuildAddToCollectionControl"/>
      <!-- <xsl:call-template name="BackwardNavigation"/> -->

      <!-- add COinS -->
      <xsl:for-each select="$gMdpMetadata">
        <xsl:call-template name="marc2coins" />
      </xsl:for-each>

    </div>
  </xsl:template>

  <!-- FORM: Add To Collection Form -->
  <xsl:template name="BuildAddToCollectionControl">
    <div class="ptSelectBox">
      <label for="PTaddItemSelect" class="SkipLink"><xsl:text>Add to your collection:</xsl:text></label>
      <!-- for-each just for context: there's only one -->
      <xsl:for-each select="$gCollectionForm/CollectionSelect">
        <xsl:call-template name="BuildHtmlSelect">
          <xsl:with-param name="id" select="'PTaddItemSelect'"/>
          <xsl:with-param name="class" select="'mdpColSelectMenu'"/>
        </xsl:call-template>
      </xsl:for-each>
      <br />
      <button id="PTaddItemBtn">Add</button>

    </div>
  </xsl:template>

  <!-- AJAX: build "add item to [new] collection" request URL -->
  <xsl:template name="GetAddItemRequestUrl">

    <xsl:variable name="id">
      <xsl:value-of select="/MBooksTop/MBooksGlobals/CurrentCgi/Param[@name='id']"/>
    </xsl:variable>

    <xsl:variable name="ajax_request_partial_url">
        <xsl:choose>
          <xsl:when test="$gUsingSearch = 'true'">
            <xsl:text>../</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text></xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="concat('mb?', 'page=ajax', ';id=', $id )"/>
    </xsl:variable>

    <div id="PTajaxAddItemPartialUrl" class="hidden">
          <xsl:value-of select="$ajax_request_partial_url"/>

    </div>


  </xsl:template>

  <xsl:template name="BuildBackToResultsLink">
    <div id="mdpBackToResults">
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="//SearchForm/SearchResultsLink" />
        </xsl:attribute>
        <xsl:attribute name="class">tracked</xsl:attribute>
        <xsl:attribute name="data-tracking-category">PT</xsl:attribute>
        <xsl:attribute name="data-tracking-action">PT Back to Search Results</xsl:attribute>
        <xsl:text>&#171; Back to </xsl:text>
        <xsl:apply-templates select="//SearchForm/SearchResultsLabel" mode="copy" />
      </xsl:element>
    </div>
  </xsl:template>

  <xsl:template match="SearchResultsLabel" mode="copy">
    <xsl:apply-templates select="@*|*|text()" mode="copy" />
  </xsl:template>

  <xsl:template match="@*|*|text()" mode="copy">
    <xsl:copy>
      <xsl:apply-templates select="@*|*|text()" mode="copy" />
    </xsl:copy>
  </xsl:template>

  <!-- -->
  <xsl:template match="Highlight">
    <xsl:element name="span">
      <xsl:copy-of select="@class"/>
      <xsl:apply-templates select="." mode="copy" />
    </xsl:element>
  </xsl:template>

  <!-- Preserve line breaks in OCR -->
  <xsl:template match="br">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="@*|*|text()" mode="copy">
    <xsl:copy>
      <xsl:apply-templates select="@*|*|text()" mode="copy" />
    </xsl:copy>
  </xsl:template>

  <xsl:template name="heading1">
    <xsl:element name="h1">
      <xsl:attribute name="class">offscreen</xsl:attribute>
      <xsl:call-template name="PageTitle" />
    </xsl:element>
  </xsl:template>

  <xsl:template name="PageTitle">
    <xsl:param name="detail" select="''" />
    <xsl:param name="suffix" select="'HathiTrust Digital Library'" />
    <xsl:param name="dash" select="'-'" />
    <xsl:param name="title" />
    <xsl:param name="tail" />

    <xsl:variable name="displayed-title">
      <xsl:choose>
        <xsl:when test="normalize-space($title)">
          <xsl:value-of select="normalize-space($title)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="truncated-title">
            <xsl:call-template name="GetMaybeTruncatedTitle">
              <xsl:with-param name="titleString" select="$gTitleString"/>
              <xsl:with-param name="titleFragment" select="$gVolumeTitleFragment"/>
              <xsl:with-param name="maxLength" select="$gTitleTruncAmt"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:value-of select="normalize-space($truncated-title)" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="normalize-space($detail)">
        <xsl:value-of select="concat(' ', $dash, ' ')" />
        <xsl:value-of select="$detail" />
      </xsl:if>
    </xsl:variable>

    <xsl:value-of select="$displayed-title" />
    <xsl:choose>
      <xsl:when test="$gRightsAttribute='8'">
        <xsl:text> - Item Not Available </xsl:text>
      </xsl:when>
      <xsl:when test="/MBooksTop/MBooksGlobals/FinalAccessStatus='allow'">
        <xsl:text> - Full View </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> - Limited View </xsl:text>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="normalize-space($suffix)">
      <xsl:text> | </xsl:text>
      <xsl:value-of select="$suffix" />
    </xsl:if>

    <xsl:if test="normalize-space($tail)">
      <xsl:text> (</xsl:text>
      <xsl:value-of select="$tail" />
      <xsl:text>)</xsl:text>
    </xsl:if>

  </xsl:template>

  <!-- need to move the anchor elsewhere -->
  <xsl:template name="skipNavAnchor">
  </xsl:template>


</xsl:stylesheet>

