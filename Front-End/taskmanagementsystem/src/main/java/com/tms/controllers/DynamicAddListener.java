package com.tms.controllers;

import javax.servlet.*;

import javax.servlet.annotation.WebListener;

import com.tms.java.Utilities;

@WebListener()
public class DynamicAddListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent event) {
        Utilities loadPropertiesFile = new Utilities();
        event.getServletContext().setAttribute("URL",
                loadPropertiesFile.getPropertyValue("ServiceUrl", "config1.properties"));

    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {

    }
}
