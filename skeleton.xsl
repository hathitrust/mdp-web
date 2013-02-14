<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [ 
<!ENTITY nbsp "&#160;"> 
<!ENTITY copy "&#169;">
<!ENTITY raquo "»"> 
<!ENTITY laquo "«"> 
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
  xmlns:exsl="http://exslt.org/common"
  xmlns:h="http://www.hathitrust.org"
  xmlns="http://www.w3.org/1999/xhtml"
  extension-element-prefixes="exsl">
  
  <xsl:variable name="gFinalAccessStatus" select="/MBooksTop/MBooksGlobals/FinalAccessStatus"/>
  <xsl:variable name="gHttpHost" select="/MBooksTop/MBooksGlobals/HttpHost"/>
  <xsl:variable name="gHtId" select="/MBooksTop/MBooksGlobals/HtId"/>

  <xsl:variable name="gLoggedIn" select="/MBooksTop/MBooksGlobals/LoggedIn"/>
  <xsl:variable name="gQ1" select="/MBooksTop/MBooksGlobals/CurrentCgi/Param[@name='q1']" />

  <xsl:variable name="search-options">
      <option value="all">Everything</option>
      <option value="title">Title</option>
      <option value="author">Author</option>
      <option value="subject">Subject</option>
      <option value="isbn">ISBN/ISSN</option>
      <option value="publisher">Publisher</option>
      <option value="seriestitle">Series Title</option>
      <option value="pubyear">Publication Year</option>
  </xsl:variable>

  <xsl:template match="/MBooksTop">
    <html lang="en" xml:lang="en" xmlns="http://www.w3.org/1999/xhtml">
      <xsl:attribute name="class">
        <xsl:text>no-js </xsl:text>
        <xsl:call-template name="setup-html-class" />
      </xsl:attribute>

      <head>

        <xsl:comment>IE PRE-SETUP</xsl:comment>

        <link rel="stylesheet" type="text/css" href="/common/unicorn/vendors/css/normalize.css" />

        <link rel="stylesheet" type="text/css" href="/common/unicorn/vendors/icomoon/style.css" />

        <script type="text/javascript" src="/common/unicorn/vendors/js/modernizr.custom.79639.js"></script> 

        <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.8/jquery.min.js"></script>
        <script type="text/javascript" src="/common/unicorn/vendors/js/underscore-min.js"></script>

        <link rel="stylesheet" type="text/css" href="/common/unicorn/vendors/css/bootstrap-forms.css" />
        <link rel="stylesheet" type="text/css" href="/common/unicorn/css/common.css" />

        <xsl:call-template name="setup-extra-header" />

        <xsl:comment>IE POST-SETUP</xsl:comment>

        <title>
          <xsl:call-template name="setup-page-title" />
        </title>

      </head>

      <body>
        <xsl:attribute name="class">
          <xsl:call-template name="setup-body-class" />
        </xsl:attribute>

        <h1 class="offscreen"><xsl:call-template name="setup-page-title" /></h1>

        <xsl:call-template name="navbar" />
        <xsl:call-template name="header" />

        <xsl:call-template name="page-contents" />

        <xsl:call-template name="footer" />
      </body>

    </html>

  </xsl:template>

  <xsl:template name="setup-html-class" />
  <xsl:template name="setup-extra-header" />
  <xsl:template name="setup-body-class" />

  <xsl:template name="setup-page-title">
    <xsl:variable name="page-title">
      <xsl:call-template name="get-page-title" />
    </xsl:variable>
    <xsl:if test="normalize-space($page-title)">
      <xsl:value-of select="$page-title" /><xsl:text> | </xsl:text>
    </xsl:if>
    <xsl:text>HathiTrust Digital Library</xsl:text>
  </xsl:template>

  <xsl:template name="navbar">
    <div class="navbar navbar-static-top navbar-inverse">
      <div class="navbar-inner">
        <ul id="nav" class="nav">
          <li><a href="http://www.hathitrust.org">Home</a></li>
          <li><a href="http://www.hathitrust.org/about">About</a>
            <ul>
              <li><a href="http://www.hathitrust.org/partnership">Our Partnership</a></li>
              <li><a href="http://www.hathitrust.org/digital_library">Our Digital Library</a></li>
              <li><a href="http://www.hathitrust.org/htrc">Our Research Center</a></li>
              <li><a href="http://www.hathitrust.org/news_publications">News &amp; Publications</a></li>
            </ul>
          </li>
          <li><a href="http://babel.hathitrust.org/cgi/mb">Collections</a></li>
          <li class="divider-vertical"></li>
          <li class="help"><a href="http://www.hathitrust.org/help">Help</a></li>
          <li><a href="#">Feedback</a></li>
        </ul>
        <xsl:if test="$gLoggedIn = 'YES'">
          <ul id="person-nav" class="nav pull-right">
            <li><span>Hi bjensen!</span></li>
            <li><a href="http://babel.hathitrust.org/cgi/mb?a=listcs;colltype=priv">My Collections</a></li>
            <li><a href="http://babel.hathitrust.org/cgi/logout">Logout</a></li>
          </ul>
        </xsl:if>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="header">
    <div class="container centered header clearfix">
      <div class="logo">
        <a href="http://www.hathitrust.org"><span class="offscreen">HathiTrust Digital Library</span></a>
      </div>
      <div class="search-form">

        <form action="/cgi/ls/one" method="GET">
          <div class="search-tabs">
            <input name="target" type="radio" id="option-full-text-search" value="ls" checked="checked" />
            <label for="option-full-text-search" class="search-label-full-text">Full-text</label>
            <input name="target" type="radio" id="option-catalog-search" value="catalog" />
            <label for="option-catalog-search" class="search-label-catalog">Catalog</label>
          </div>
          <fieldset>
            <input name="q1" type="text" class="search-input-text" placeholder="Search words about or within the items" value="{$gQ1}" />
            <div class="search-input-options">
              <select size="1" class="search-input-select" name="searchtype">
                <xsl:call-template name="search-input-select-options" />
              </select>
            </div>
            <button class="button"><span class="offscreen">Search</span></button>
          </fieldset>
          <div class="search-extra-options">
            <ul class="search-links">
              <li class="search-advanced-link"><a href="#">Advanced full-text search</a></li>
              <li class="search-catalog-link"><a href="#">Advanced catalog search</a></li>
              <li><a href="#">Search tips</a></li>
            </ul>
            <xsl:call-template name="search-ft-checkbox" />
          </div>
        </form>

      </div>
      <xsl:call-template name="login-block" />
    </div>    
  </xsl:template>

  <xsl:template name="footer">
    <div class="navbar navbar-static-bottom navbar-inverse footer">
      <div class="navbar-inner">
        <xsl:if test="$gLoggedIn = 'YES'">
          <ul id="nav" class="nav">
            <li>
              <span>University of Michigan<br />Member, HathiTrust
              </span>
            </li>
          </ul>
        </xsl:if>
        <ul class="nav pull-right">
          <li><a href="http://www.hathitrust.org/">Home</a></li>
          <li><a href="http://www.hathitrust.org/about">About</a></li>
          <li><a href="http://babel.hathitrust.org/cgi/mb">Collections</a></li>
          <li><a href="http://www.hathitrust.org/help">Help</a></li>
          <li><a href="#">Feedback</a></li>
          <li><a href="http://m.hathitrust.org">Mobile</a></li>
          <li><a href="http://www.hathitrust.org/take_down_policy">Take-Down Policy</a></li>
          <li><a href="http://www.hathitrust.org/privacy">Privacy</a></li>
          <li><a href="http://www.hathitrust.org/contact">Contact</a></li>
        </ul>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="page-contents">
    <div class="container page centered">
      <xsl:call-template name="contents" />
    </div>
  </xsl:template>

  <xsl:template name="get-page-contents" />

  <xsl:template name="login-block">
    <div class="login">
      <xsl:choose>
        <xsl:when test="$gLoggedIn = 'YES'">
          <!-- we don't do anything normally -->
        </xsl:when>
        <xsl:otherwise>
          <a href="#" id="login-button" class="button log-in">LOG IN</a>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

  <xsl:template name="search-input-select-options">
    <xsl:for-each select="exsl:node-set($search-options)/*">
      <option value="{@value}">
        <xsl:if test="@value = $gQ1">
          <xsl:attribute name="selected">selected</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="." />
      </option>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="search-ft-checkbox">
    <xsl:param name="checked" select="'checked'" />
    <label>
      <input type="checkbox" value="ft" checked="{$checked}" />
      Full view only
    </label>
  </xsl:template>

</xsl:stylesheet>