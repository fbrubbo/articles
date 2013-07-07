package com.myapp;

import java.io.IOException;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = { "/time" })
public class TimeServlet extends HttpServlet {
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
		ServletOutputStream out = response.getOutputStream();
		out.print(new Date().toString());
		out.flush();
    }
}
