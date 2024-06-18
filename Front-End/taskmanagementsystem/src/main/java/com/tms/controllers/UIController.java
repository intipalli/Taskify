package com.tms.controllers;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class UIController {

	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public ModelAndView getloginPage(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("login");

		return mav;
	}

	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public ModelAndView getlogoutPage(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("login");
		return mav;
	}

	@RequestMapping(value = "/logoutUser", method = RequestMethod.GET)
	public ModelAndView doLogout(ModelAndView mav, HttpServletRequest request) {
		try {

			request.getSession().removeAttribute("TOKEN");
			request.getSession().removeAttribute("Role");
			mav = new ModelAndView("redirect:/login");
			return mav;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return mav;
	}

	@RequestMapping(value = "/home", method = RequestMethod.GET)
	public ModelAndView getHomePage(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();

		if (request.getSession().getAttribute("TOKEN") == null
				|| request.getSession().getAttribute("TOKEN").equals("")) {
			mv = new ModelAndView("redirect:/login");
			return mv;
		} else {
			mv.addObject("fullName", request.getSession().getAttribute("fullName"));
			mv.setViewName("homepage");
			return mv;
		}
	}

	@RequestMapping(value = "/error", method = RequestMethod.GET)
	public ModelAndView getErrorPage() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("error");
		return mv;
	}

	@RequestMapping(value = "/addTask", method = RequestMethod.GET)
	public ModelAndView addTask(@RequestParam("sprintId") int id, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		if (request.getSession().getAttribute("TOKEN") == null
				|| request.getSession().getAttribute("TOKEN").equals("")) {
			mv = new ModelAndView("redirect:/login");
			return mv;
		}
		mv.setViewName("addtask");
		mv.addObject("sprintId", id);
		return mv;
	}

	@RequestMapping(value = "/listTasks", method = RequestMethod.GET)
	public ModelAndView getlistTasksPage(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		if (request.getSession().getAttribute("TOKEN") == null
				|| request.getSession().getAttribute("TOKEN").equals("")) {
			mv = new ModelAndView("redirect:/login");
			return mv;
		}
		mv.setViewName("listtasks");
		return mv;
	}

	@RequestMapping(value = "/listUsers", method = RequestMethod.GET)
	public ModelAndView getlistUsersPage(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		if (request.getSession().getAttribute("TOKEN") == null
				|| request.getSession().getAttribute("TOKEN").equals("")) {
			mv = new ModelAndView("redirect:/login");
			return mv;
		}
		mv.setViewName("listusers");
		return mv;
	}

	@RequestMapping(value = "/taskreport", method = RequestMethod.GET)
	public ModelAndView getTaskReportPage(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		if (request.getSession().getAttribute("TOKEN") == null
				|| request.getSession().getAttribute("TOKEN").equals("")) {
			mv = new ModelAndView("redirect:/login");
			return mv;
		}
		mv.setViewName("taskreport");
		return mv;
	}

	@RequestMapping(value = "/editProfile", method = RequestMethod.GET)
	public ModelAndView editProfile(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		if (request.getSession().getAttribute("TOKEN") == null
				|| request.getSession().getAttribute("TOKEN").equals("")) {
			mv = new ModelAndView("redirect:/login");
			return mv;
		}
		mv.addObject("firstName", request.getSession().getAttribute("firstName"));
		mv.addObject("lastName", request.getSession().getAttribute("lastName"));
		mv.addObject("email", request.getSession().getAttribute("Email"));
		mv.addObject("userName", request.getSession().getAttribute("Username"));
		mv.addObject("mobile", request.getSession().getAttribute("phone"));
		mv.addObject("uid", request.getSession().getAttribute("userId"));
		mv.setViewName("editprofile");
		return mv;
	}

	@RequestMapping(value = "/changePassword", method = RequestMethod.GET)
	public ModelAndView resetPassword(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		if (request.getSession().getAttribute("TOKEN") == null
				|| request.getSession().getAttribute("TOKEN").equals("")) {
			mv = new ModelAndView("redirect:/login");
			return mv;
		}
		mv.addObject("userName", request.getSession().getAttribute("Username"));
		mv.setViewName("changePassword");
		return mv;
	}

	@RequestMapping(value = "/resetPassword", method = RequestMethod.GET)
	public ModelAndView rp(@RequestParam("userName") String un, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("userName", un);
		mv.setViewName("resetPassword");
		return mv;
	}

	@RequestMapping(value = "/addUser", method = RequestMethod.GET)
	public ModelAndView getAddUserPage(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		if (request.getSession().getAttribute("TOKEN") == null
				|| request.getSession().getAttribute("TOKEN").equals("")) {
			mv = new ModelAndView("redirect:/login");
			return mv;
		}
		mv.setViewName("addUser");
		return mv;
	}

	@RequestMapping(value = "/taskHistory", method = RequestMethod.GET)
	public ModelAndView getTaskHistoryPage(@RequestParam("taskId") int taskId, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		if (request.getSession().getAttribute("TOKEN") == null
				|| request.getSession().getAttribute("TOKEN").equals("")) {
			mv = new ModelAndView("redirect:/login");
			return mv;
		}
		mv.setViewName("taskhistory");

		mv.addObject("taskId", taskId);
		return mv;

	}

	@RequestMapping(value = "/addSprint", method = RequestMethod.GET)
	public ModelAndView getAddSprintPage(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		if (request.getSession().getAttribute("TOKEN") == null
				|| request.getSession().getAttribute("TOKEN").equals("")) {
			mv = new ModelAndView("redirect:/login");
			return mv;
		}
		mv.setViewName("addsprint");
		return mv;
	}

	@RequestMapping(value = "/listSprints", method = RequestMethod.GET)
	public ModelAndView getListSprintsPage(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		if (request.getSession().getAttribute("TOKEN") == null
				|| request.getSession().getAttribute("TOKEN").equals("")) {
			mv = new ModelAndView("redirect:/login");
			return mv;
		}
		mv.setViewName("listsprints");
		return mv;
	}

	@RequestMapping(value = "/sprintTasks", method = RequestMethod.GET)
	public ModelAndView getSprintTasksPage(@RequestParam("sprintId") int id, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		if (request.getSession().getAttribute("TOKEN") == null
				|| request.getSession().getAttribute("TOKEN").equals("")) {
			mv = new ModelAndView("redirect:/login");
			return mv;
		}
		mv.setViewName("listsprinttasks");

		mv.addObject("sprintId", id);
		return mv;

	}

}
