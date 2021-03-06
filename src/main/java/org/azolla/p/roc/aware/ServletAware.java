/*
 * @(#)Init.java		Created at 15/4/20
 * 
 * Copyright (c) azolla.org All rights reserved.
 * Azolla PROPRIETARY/CONFIDENTIAL. Use is subject to license terms. 
 */
package org.azolla.p.roc.aware;

import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.ServletContextAware;

import javax.servlet.ServletContext;

/**
 * The coder is very lazy, nothing to write for this class
 *
 * @author sk@azolla.org
 * @since ADK1.0
 */
@Component
public class ServletAware implements InitializingBean, ServletContextAware
{
    private ServletContext servletContext;

    @Autowired
    private CacheAware cacheAware;

    @Override
    public void setServletContext(ServletContext servletContext)
    {
        this.servletContext = servletContext;
    }

    @Override
    public void afterPropertiesSet() throws Exception
    {
        servletContext.setAttribute(CacheAware.LEFT_CATEGORY_LST, cacheAware.getCategoryList(CacheAware.LEFT_CATEGORY_LST));
        servletContext.setAttribute(CacheAware.RIGHT_CATEGORY_LST, cacheAware.getCategoryList(CacheAware.RIGHT_CATEGORY_LST));
        servletContext.setAttribute(CacheAware.CONFIG_CACHE,cacheAware.getConfigMap());
        servletContext.setAttribute(CacheAware.TAG_CACHE,cacheAware.getTagList());
        servletContext.setAttribute("TAG4KEYWORD",cacheAware.getTagDisplayNameString());
    }

    public static String getGenerateQrcodePath()
    {
        return "/generate/img/qrcode";
    }
}
