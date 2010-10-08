<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:METS="http://www.loc.gov/METS/"
  xmlns:PREMIS="http://www.loc.gov/standards/premis"
  >
  
  <!--
       Copyright 2006, The Regents of The University of Michigan, All Rights Reserved
       
       Permission is hereby granted, free of charge, to any person obtaining
       a copy of this software and associated documentation files (the
       "Software"), to deal in the Software without restriction, including
       without limitation the rights to use, copy, modify, merge, publish,
       distribute, sublicense, and/or sell copies of the Software, and to
       permit persons to whom the Software is furnished to do so, subject
       to the following conditions:
       
       The above copyright notice and this permission notice shall be
       included in all copies or substantial portions of the Software.
       
       THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
       EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
       MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
       IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
       CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
       TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
       SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
       -->
  
  <!-- Global Variables -->
  <xsl:variable name="gPodUrl" select="/MBooksTop/MBooksGlobals/Pod/Url"/>
  <xsl:variable name="gSkin" select="/MBooksTop/MBooksGlobals/Skin"/>
  <xsl:variable name="gSdrInst" select="/MBooksTop/MBooksGlobals/EnvSDRINST"/>
  <xsl:variable name="gRightsAttribute" select="/MBooksTop/MBooksGlobals/RightsAttribute"/>
  <xsl:variable name="gSourceAttribute" select="/MBooksTop/MBooksGlobals/SourceAttribute"/>
  <xsl:variable name="gMdpMetadata" select="/MBooksTop/METS:mets/METS:dmdSec/present/record/metadata/oai_marc"/>
  <xsl:variable name="gItemHandle" select="/MBooksTop/MBooksGlobals/ItemHandle"/>
  <xsl:variable name="gLoggedIn" select="/MBooksTop/MBooksGlobals/LoggedIn"/>
  <xsl:variable name="gHathiTrustAffiliate" select="/MBooksTop/MBooksGlobals/HathiTrustAffiliate"/>
  <xsl:variable name="gMichiganAffiliate" select="/MBooksTop/MBooksGlobals/MichiganAffiliate"/>
  <xsl:variable name="gCurrentQ1" select="/MBooksTop/MBooksGlobals/CurrentCgi/Param[@name='q1']"/>
  <xsl:variable name="gContactEmail" select="/MBooksTop/MBooksGlobals/ContactEmail"/>
  <xsl:variable name="gContactText" select="/MBooksTop/MBooksGlobals/ContactText"/>
  <xsl:variable name="gVolumeTitleFragment" select="concat(' ', /MBooksTop/MBooksGlobals/VolCurrTitleFrag)"/>
  <xsl:variable name="gTitleTrunc">
    <xsl:choose>
      <xsl:when test="/MBooksTop/MBooksGlobals/SSDSession='false'">
        <xsl:choose>
          <xsl:when test="$gVolumeTitleFragment!=' '">
            <xsl:value-of select="'40'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'50'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'9999'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="gFullTitleString">
    <xsl:if test="$gMdpMetadata/varfield[@id='245']/subfield[@label='a']">
      <xsl:value-of select="$gMdpMetadata/varfield[@id='245']/subfield[@label='a']"/>
    </xsl:if>
    <xsl:if test="$gMdpMetadata/varfield[@id='245']/subfield[@label='b']">
      <xsl:value-of select="concat(' ', $gMdpMetadata/varfield[@id='245']/subfield[@label='b'])"/>
    </xsl:if>
    <xsl:if test="$gMdpMetadata/varfield[@id='245']/subfield[@label='c']">
      <xsl:value-of select="concat(' ', $gMdpMetadata/varfield[@id='245']/subfield[@label='c'])"/>
    </xsl:if>
  </xsl:variable>
  
  <!-- Navigation bar -->
  <xsl:template name="subnav_header">
    
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
      </div>
    </div>
    
  </xsl:template>
  
  
  <!-- METADATA: All journal links -->
  <xsl:template name="BuildAllJournalLinksPopup">
    
  </xsl:template>
  
  <!-- METADATA: author metadata helper -->
  <xsl:template name="MetadataAuthorHelper">
    <xsl:for-each select="$gMdpMetadata/varfield[@id='100']">
      <xsl:if test="subfield[@label='a']">
        <xsl:value-of select="subfield[@label='a']"/>
      </xsl:if>
      <xsl:if test="subfield[@label='b']">
        <xsl:text>&#x20;</xsl:text>
        <xsl:value-of select="subfield[@label='b']"/>
      </xsl:if>
      <xsl:if test="subfield[@label='c']">
        <xsl:text>&#x20;</xsl:text>
        <xsl:value-of select="subfield[@label='c']"/>
      </xsl:if>
      <xsl:if test="subfield[@label='e']">
        <xsl:text>&#x20;</xsl:text>
        <xsl:value-of select="subfield[@label='e']"/>
      </xsl:if>
      <xsl:if test="subfield[@label='q']">
        <xsl:text>&#x20;</xsl:text>
        <xsl:value-of select="subfield[@label='q']"/>
      </xsl:if>
      <xsl:if test="subfield[@label='d']">
        <xsl:text>&#x20;</xsl:text>
        <xsl:value-of select="subfield[@label='d']"/>
      </xsl:if>
    </xsl:for-each>
    
    <xsl:for-each select="$gMdpMetadata/varfield[@id='110']">
      <xsl:value-of select="subfield[@label='a']"/>
      <xsl:if test="subfield[@label='b']">
        <xsl:text>&#32;</xsl:text>
        <xsl:value-of select="subfield[@label='c']"/>
      </xsl:if>
    </xsl:for-each>
    
    <xsl:for-each select="$gMdpMetadata/varfield[@id='111']">
      <xsl:value-of select="subfield[@label='a']"/>
    </xsl:for-each>

  </xsl:template>
  
  <!-- METADATA: MDP-style metadata helper -->
  <xsl:template name="MdpMetadataHelper">
    <xsl:param name="ssd"/>
    <div id="mdpFlexible_1">
      
      <xsl:if test="$gMdpMetadata/varfield[@id='100']/subfield or $gMdpMetadata/varfield[@id='110']/subfield or $gMdpMetadata/varfield[@id='111']/subfield">
        <div class="mdpMetaDataRow">
          <div class="mdpMetaDataRegionHead">
            <xsl:text>Author&#xa0;</xsl:text>
          </div>
          <div class="mdpMetaText">
            <xsl:call-template name="MetadataAuthorHelper"/>
          </div>
        </div>
      </xsl:if>
      
      <xsl:if test="$gMdpMetadata/varfield[@id='250']/subfield">
        <div class="mdpMetaDataRow">
          <div class="mdpMetaDataRegionHead">
            <xsl:text>Edition&#xa0;</xsl:text>
          </div>
          <div class="mdpMetaText">
            <xsl:value-of select="$gMdpMetadata/varfield[@id='250']/subfield"/>
          </div>
        </div>
      </xsl:if>
      
      <div class="mdpMetaDataRow">
        <div class="mdpMetaDataRegionHead">
          <xsl:text>Published&#xa0;</xsl:text>
        </div>
        <div class="mdpMetaText">
          <xsl:if test="$gMdpMetadata/varfield[@id='260']/subfield[@label='a']">
            <xsl:value-of select="$gMdpMetadata/varfield[@id='260']/subfield[@label='a']"/>
            &#x20;
          </xsl:if>
          <xsl:if test="$gMdpMetadata/varfield[@id='260']/subfield[@label='b']">
            <xsl:value-of select="$gMdpMetadata/varfield[@id='260']/subfield[@label='b']"/>
            &#x20;
          </xsl:if>
          <xsl:if test="$gMdpMetadata/varfield[@id='260']/subfield[@label='c']">
            <xsl:value-of select="$gMdpMetadata/varfield[@id='260']/subfield[@label='c']"/>
          </xsl:if>
        </div>
      </div>
      
      <xsl:choose>
        <xsl:when test="$gMdpMetadata/varfield[@id='MDP']/subfield[@label='h']">
          <div class="mdpMetaDataRow">
            <div class="mdpMetaDataRegionHead">
              <xsl:text>Orig. Call No.&#xa0;</xsl:text>
            </div>
            <div class="mdpMetaText">
              <xsl:value-of select="$gMdpMetadata/varfield[@id='MDP']/subfield[@label='h']"/>
            </div>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="$gMdpMetadata/varfield[@id='050']/subfield[@label='a']">
            <div class="mdpMetaDataRow">
              <div class="mdpMetaDataRegionHead">
                <xsl:text>Orig. Call No.&#xa0;</xsl:text>
              </div>
              <div class="mdpMetaText">
                <xsl:value-of select="$gMdpMetadata/varfield[@id='050']/subfield[@label='a']"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$gMdpMetadata/varfield[@id='050']/subfield[@label='b']"/>
              </div>
            </div>
          </xsl:if>
        </xsl:otherwise>  
      </xsl:choose>
      
      <xsl:if test="$gMdpMetadata/varfield[@id='300']/subfield">
        <div class="mdpMetaDataRow">
          <div class="mdpMetaDataRegionHead">
            <xsl:text>Description&#xa0;</xsl:text>
          </div>
          <div class="mdpMetaText">
            <xsl:value-of select="$gMdpMetadata/varfield[@id='300']/subfield[@label='a']"/>
            &#x20;
            <xsl:value-of select="$gMdpMetadata/varfield[@id='300']/subfield[@label='b']"/>
            &#x20;
            <xsl:value-of select="$gMdpMetadata/varfield[@id='300']/subfield[@label='c']"/>
          </div>
        </div>
      </xsl:if>
      
      <xsl:if test="$gRightsAttribute">
        <div class="mdpMetaDataRow">
          <div class="mdpMetaDataRegionHead">
            <xsl:text>Copyright&#xa0;</xsl:text>
          </div>
          <div class="mdpMetaText">
            <xsl:element name="a">
              <xsl:attribute name="href">http://www.hathitrust.org/faq#RightsCodes</xsl:attribute>
              <xsl:choose>
                <xsl:when test="$gRightsAttribute='1'">
                  <xsl:text>Public Domain</xsl:text>
                </xsl:when>
                <xsl:when test="$gRightsAttribute='2'">
                  <xsl:text>In-copyright</xsl:text>
                </xsl:when>
                <xsl:when test="$gRightsAttribute='3'">
                  <xsl:text>In-copyright</xsl:text>
                </xsl:when>
                <xsl:when test="$gRightsAttribute='4'">
                  <xsl:text>In-copyright</xsl:text>
                </xsl:when>
                <xsl:when test="$gRightsAttribute='5'">
                  <xsl:text>Undetermined copyright status</xsl:text>
                </xsl:when>
                <xsl:when test="$gRightsAttribute='6'">
                  <xsl:text>Available to U-M affiliates and walk-in patrons (all
                  campuses)</xsl:text>
                </xsl:when>
                <xsl:when test="$gRightsAttribute='7'">
                  <xsl:text>Available to everyone in the world</xsl:text>
                </xsl:when>
                <xsl:when test="$gRightsAttribute='8'">
                  <xsl:text>Available to nobody; blocked for all users</xsl:text>
                </xsl:when>
                <xsl:when test="$gRightsAttribute='9'">
                  <xsl:text>Public domain only when viewed in the US</xsl:text>
                </xsl:when>
                <xsl:otherwise/>
              </xsl:choose> 
            </xsl:element>
          </div>
        </div>
      </xsl:if>
      
      <xsl:if test="$gSourceAttribute">
        <div class="mdpMetaDataRow">
          <div class="mdpMetaDataRegionHead">
            <xsl:text>Access and Use&#xa0;</xsl:text>
          </div>
          <div class="mdpMetaText">
            <xsl:choose>
              <xsl:when test="$gRightsAttribute='1' or $gRightsAttribute='7' or $gRightsAttribute='9'">
                <xsl:choose>
                  <xsl:when test="$gSourceAttribute='1'">
                    <xsl:text>Users are free to download, cite and link to this digital item. Downloaded portions may not be redistributed, rehosted, or used commercially.</xsl:text>
                  </xsl:when>
                  <xsl:when test="$gSourceAttribute='2'">
                    <xsl:text>Users are free to download, copy, and distribute this work without asking for permission.</xsl:text>
                  </xsl:when>
                  <xsl:otherwise/>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="$gRightsAttribute='2' or $gRightsAttribute='3' or $gRightsAttribute='4'">
                <xsl:text>This item is keyword searchable only. Page images and full text are not available due to copyright restrictions.</xsl:text> 
              </xsl:when>
              <xsl:when test="$gRightsAttribute='6'">
                <xsl:text>This item is keyword searchable only. The copyright status is undetermined and it is treated as though it were in copyright.</xsl:text>
              </xsl:when>
              <xsl:when test="$gRightsAttribute='8'">
                <xsl:text>This item is keyword searchable only. Viewing is restricted while issues regarding display are resolved.</xsl:text>
              </xsl:when>
              <xsl:otherwise/>
            </xsl:choose>
          </div>
        </div>
      </xsl:if>
      
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
        
        <div class="mdpMetaText">
          <xsl:call-template name="GetMaybeTruncatedTitle">
            <xsl:with-param name="titleString" select="$gFullTitleString"/>
            <xsl:with-param name="titleFragment" select="$gVolumeTitleFragment"/>
            <xsl:with-param name="maxLength" select="$gTitleTrunc"/>
          </xsl:call-template>
        </div>
      </div>
      
      <!-- Author, Edition, Published, Description -->
      <xsl:call-template name="MdpMetadataHelper"/>
    </div>
    
  </xsl:template>
  
  <!-- Link to HathiTrust VuFind -->
  <xsl:template name="hathiVuFind">

<div class="bibLinks">
    
    <ul>
      <li>
        <xsl:element name="a">
          <xsl:attribute name="class">catalog</xsl:attribute>
          <xsl:attribute name="href">
            <xsl:text>http://catalog.hathitrust.org/Record/</xsl:text>
            <xsl:value-of select="/MBooksTop/METS:mets/METS:dmdSec/present/record/doc_number"/>
          </xsl:attribute>
          <xsl:attribute name="title">Link to the HathiTrust VuFind Record for this item</xsl:attribute>
          <xsl:text>Catalog record</xsl:text>
        </xsl:element>  
      </li>      
      <li>
        <xsl:for-each select="/MBooksTop/METS:mets/METS:dmdSec/present/record/metadata/oai_marc/varfield[@id='035'][contains(.,'OCoLC)ocm') or contains(.,'OCoLC') or contains(.,'oclc') or contains(.,'ocm') or contains(.,'ocn')][1]">
          <xsl:element name="a">
            <xsl:attribute name="class">worldcat</xsl:attribute>
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

               <xsl:text>Find in a library</xsl:text>

          </xsl:element>
        </xsl:for-each>
      </li>

      <xsl:if test="$gPodUrl != ''">
        <li>
          <div id="podURL">
            <xsl:element name="a">
              <xsl:attribute name="class">pod</xsl:attribute>
              <xsl:attribute name="href">
                <xsl:value-of select="$gPodUrl"/>
              </xsl:attribute>

          <xsl:if test="$gGoogleOnclickTracking = 'true'">
            <xsl:attribute name="onclick">
              <xsl:call-template name="PageTracker">
                <xsl:with-param name="category" select="'outLinks'"/>
                <xsl:with-param name="action" select="'click'"/>
                <xsl:with-param name="label" select="'PT Buy a reprint'"/>
              </xsl:call-template>
            </xsl:attribute>
          </xsl:if>

              <xsl:text>Buy a copy</xsl:text>
            </xsl:element>
          </div>
        </li>
      </xsl:if>
    </ul>

  </div>

        <div id="permURL">
          <form action="" name="urlForm" id="urlForm">
            <label for="permURL" class="permalink">Permanent Link</label>
            <xsl:element name="input">
              <xsl:attribute name="type">text</xsl:attribute>
              <xsl:attribute name="name">permURL_link</xsl:attribute>
              <xsl:attribute name="id">permURL</xsl:attribute>
              <xsl:attribute name="class">email-permURL</xsl:attribute>
              <xsl:attribute name="onclick">javascript:document.urlForm.video_link.focus();</xsl:attribute>
              <xsl:attribute name="onclick">document.urlForm.permURL_link.select();
               <xsl:if test="$gGoogleOnclickTracking = 'true'">
                  <xsl:call-template name="PageTracker">
                  <xsl:with-param name="label" select="'PT Perm Link'"/>
                </xsl:call-template>
               </xsl:if>
            </xsl:attribute>
              <xsl:attribute name="readonly">readonly = true;</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="$gItemHandle"/>
              </xsl:attribute>
            </xsl:element>
          </form>
        </div>
    
  </xsl:template>
  
  
  <!-- New Bookmark -->
  <xsl:template name="ItemBookmark">
    <div class="mdpBookmark">
      <xsl:choose>
        <xsl:when test="$gItemHandle=''">
          <xsl:text>not available</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <!-- -->
          <xsl:variable name="bookmarkTitle">
            <xsl:call-template name="GetMaybeTruncatedTitle">
              <xsl:with-param name="titleString" select="$gFullTitleString"/>
              <xsl:with-param name="titleFragment" select="$gVolumeTitleFragment"/>
              <xsl:with-param name="maxLength" select="$gTitleTrunc"/>
            </xsl:call-template>
          </xsl:variable>
          <!-- The javascript function call uses double-quoted
               parameters but the title may have double quotes in it so
               escape those -->
          <xsl:variable name="safeBookmarkTitle">
            <xsl:call-template name="ReplaceChar">
              <xsl:with-param name="string">
                <xsl:value-of select="$bookmarkTitle"/>
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
    <xsl:element name="form">
      <xsl:attribute name="onsubmit">
        <xsl:value-of select="'return FormValidation(this.q1, &quot;Please enter a term in the search box.&quot;)'"/>
      </xsl:attribute>
      <xsl:attribute name="method">get</xsl:attribute>
      <xsl:attribute name="action">
        <xsl:value-of select="'ptsearch'"/>
      </xsl:attribute>
      
      <h2 class="SkipLink">Search and page navigation options</h2>
      <ul>
        <li id="mdpSearchFormLabel">
          <label for="mdpSearchInputBox">Search in this text</label>
          <xsl:element name="a">
            <xsl:attribute name="class">SkipLink</xsl:attribute>
            <xsl:attribute name="name">SkipToSearch</xsl:attribute>
          </xsl:element>
        </li>
        <li class="asearchform">
          <xsl:apply-templates select="$pSearchForm/HiddenVars"/>
          <xsl:element name="input">
            <xsl:attribute name="id">mdpSearchInputBox</xsl:attribute>
            <xsl:attribute name="type">text</xsl:attribute>
            <xsl:attribute name="name">q1</xsl:attribute>
            <xsl:attribute name="maxlength">150</xsl:attribute>
            <xsl:attribute name="size">20</xsl:attribute>
            <xsl:attribute name="value">
              <xsl:value-of select="$gCurrentQ1"/>
            </xsl:attribute>
          </xsl:element>
          <xsl:element name="input">
            <xsl:attribute name="id">mdpSearchButton</xsl:attribute>
            <xsl:attribute name="type">submit</xsl:attribute>
            <xsl:attribute name="value">Find</xsl:attribute>
          </xsl:element>
        </li>
      </ul>
      <xsl:call-template name="HiddenDebug"/>
    </xsl:element>
    
  </xsl:template>
  
  
  <!-- Feedback -->
  <xsl:template name="Feedback">
    
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
        
        <div class="mdpFbSubtitle">
          <xsl:text>Overall page readability and quality</xsl:text>
        </div>
        <div id="mdpFlexible_2_Qual">
          <div class="mdpFbSubSubtitle">
            <input name="Quality" type="radio" value="readable" id="readable" alt="Few problems, entire page is readable"/>
            <label for="readable">Few problems, entire page is readable</label>
          </div>
          <div class="mdpFbSubSubtitle">
            <input name="Quality" type="radio" value="someproblems" id="someproblems" alt="Some problems, but still readable"/>
            <label for="someproblems">Some problems, but still readable</label>
          </div>
          <div class="mdpFbSubSubtitle">
            <input name="Quality" type="radio" value="difficult" id="difficult" alt="Significant problems, difficult or impossible to read"/>
            <label for="difficult">Significant problems, difficult or impossible to read</label>
          </div>
        </div>
        
        <div class="mdpFbSubtitle">
          <xsl:text>Specific page image problems?</xsl:text>
        </div>
        <div id="mdpFlexible_2_Spec">
          <div class="mdpFbSubSubtitle">
            <input type="checkbox" name="missing" value="1" id="missing" alt="Missing parts of the page"/>
            <label for="missing">Missing parts of the page</label>
          </div>
          <div class="mdpFbSubSubtitle">
            <input type="checkbox" name="blurry" value="1" id="blurry" alt="Blurry text"/>
            <label for="blurry">Blurry text</label>
          </div>
          <div class="mdpFbSubSubtitle">
            <input type="checkbox" name="curved" value="1" id="curved" alt="Curved or distorted text"/>
            <label for="curved">Curved or distorted text</label>
          </div>
          <div class="mdpFbSubSubtitle">
            <input type="checkbox" name="other" value="1" id="other" alt="Other problem"/>
            <label for="other">Other problem<!-- see: $FBGlobals::gOtherDescLimit --></label>
            <span><input name="other" value="" class="overlay" maxlength="50" alt="Other problem fill in"/></span>
          </div>
        </div>
        
        <div class="mdpFbSubtitle">
          <xsl:text>Problem with access rights? </xsl:text>
          <span>(See also: <a href="http://www.lib.umich.edu/policies/takedown.html"
          target="_blank">take-down policy</a>)</span>
        </div>
        <div id="mdpFlexible_2_Rights">
          <div class="mdpFbSubSubtitle">
            <input name="Rights" type="radio" value="noaccess" id="noaccess" alt="This item is in the public domain, but I don't have access to it"/>
            <label for="noaccess">This item is in the public domain, but I don't have access to it.</label>
          </div>
          <div class="mdpFbSubSubtitle">
            <input name="Rights" type="radio" value="access" id="access" alt="I have access to this item, but should not."/>
            <label for="access">I have access to this item, but should not.</label>
          </div>
        </div>
        
        
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
            <br/><span><input id="email" name="email" class="overlay" alt="Your email address" value="[Your email address]" maxlength="50" size="50" onclick="ClickClear(this, '[Your email address]')" onkeypress="ClickClear(this, '[Your email address]')"/></span>
          </div>
        </div>
        
        
        <table>
          <tr valign="bottom">
            <td><div id="emptyFBError"><strong>Error: You cannot submit an empty form.</strong></div></td>   
            <td><xsl:text>    </xsl:text></td>
            <td><input id="mdpFBinputbutton" type="submit" name="submit" value="Submit" alt="submit"/></td>
            <td width='100px' align='right'><a id='mdpFBcancel' href=''><strong>Cancel</strong></a></td>
          </tr>
        </table>
        
      </xsl:element>
      
    </div>
  </xsl:template>
  
  <!-- -->
  <xsl:template match="Highlight">
    <xsl:element name="span">
      <xsl:copy-of select="@class"/>
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>
  
  <!-- Preserve line breaks in OCR -->
  <xsl:template match="br">
    <xsl:copy-of select="."/>
  </xsl:template>

</xsl:stylesheet>
