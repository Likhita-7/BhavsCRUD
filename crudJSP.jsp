<%@ page language="java" import="java.util.*,java.sql.*,java.io.*" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<title>CRUD Assignment</title>

</head>
<body>
<center>
<h1 style="padding-top:170px;">Employee Login</h1>
<form action="CrudJsp.jsp" method="post">
<table>
<tr><td>Employee No</td><td><b>:</b></td><td><input type="number" name="empno" id="eno"></td></tr>
<tr><td>Name</td><td><b>:</b></td><td><input type="text" name="name" id="ename"></td></tr>
<tr><td>Job</td><td><b>:</b></td><td><input type="text" name="job" id="ejob"></td></tr>
<tr><td>Salary</td><td><b>:</b></td><td><input type="number" name="salary" id="esal"></td></tr>
<tr><td>Department</td><td><b>:</b></td><td><input type="text" name="dept" id="edept"></td></tr>
</table>
<br><br><div id="message"></div><br><br>
<table>
<tr>
<td><input type="submit" value="First" name="first" style="color:white; background-color:green;font-size: 15px;width: 80px; height: 22px; " ></td>
<td><input type="submit" value="Last" name="last" style="color:white; background-color:green;font-size: 15px;width: 80px; height: 22px; " ></td>
<td><input type="submit" value="Prev" name="prev" style="color:white; background-color:green;font-size: 15px;width: 80px; height: 22px; " ></td>
<td><input type="submit" value="Next" name="next" style="color:white; background-color:green;font-size: 15px;width: 80px; height: 22px; " ></td>
</tr>
<tr>
<td><input type="submit" value="Add" name="add" style="color:white; background-color:green;font-size: 15px;width: 80px; height: 22px; "></td>
<td><input type="submit" value="Edit" name="edit" style="color:white; background-color:green;font-size: 15px;width: 80px; height: 22px; " ></td>
<td><input type="submit" value="Delete" name="del" style="color:white; background-color:green;font-size: 15px;width: 80px; height: 22px; " ></td>
<td><input type="submit" value="Search" name="search" style="color:white; background-color:green;font-size: 15px;width: 80px; height: 22px; " ></td>
</tr>

</table>
<table>
<tr>
<td><input type="submit" value="Save" name="save" style="color:white; background-color:green;font-size: 15px;width: 80px; height: 22px; " ></td>
<td><input type="button" value="Clear" name="clear" style="color:white; background-color:green;font-size: 15px;width: 80px; height: 22px; "onclick="clearfun()" ></td>
<td><input type="button" value="Exit" name="exit" style="color:white; background-color:red;font-size: 15px;width: 80px; height: 22px; " ></td>

</tr>
</table>
</form>
</center>
<%
try
{
	Class.forName("org.postgresql.Driver");
	Connection conn=DriverManager.getConnection("jdbc:postgresql://192.168.110.48:5432/plf_training","plf_training_admin","pff123");
	PreparedStatement p=conn.prepareStatement("select * from chinnu_crudd",ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	
	String query="";
	if(request.getParameter("edit")!=null)
	{
		%><center><h3>Edit mode on...</h3></center><%
		System.out.println("Edit mode on");
		session.setAttribute("editRow", true);
	}
	
	
	
	
	if(request.getParameter("add")!=null && session.getAttribute("editRow")!=null)
	{
		%><center><h3>Edit mode on...</h3></center><%
		System.out.println("Edit mode on");
		session.setAttribute("addRow", true);
		String s=request.getParameter("empno")+":"+request.getParameter("name")+":"+request.getParameter("job")+":"+request.getParameter("salary")+":"+request.getParameter("dept");
		session.setAttribute("DataToAdd",s);
	}
		
	if(request.getParameter("save")!=null && session.getAttribute("addRow") != null)
	{
		session.removeAttribute("editRow");
		session.removeAttribute("addRow");
		String s=(String)session.getAttribute("DataToAdd");
		String[] res=s.split(":");
		query="insert into chinnu_crudd values(?,?,?,?,?)";
		PreparedStatement ps=conn.prepareStatement(query);
		ps.setInt(1,Integer.parseInt(res[0]));
		ps.setString(2,res[1]);
		ps.setString(3,res[2]);
		ps.setDouble(4,Double.parseDouble(res[3]));
		ps.setString(5,res[4]);
		ps.executeUpdate();
		%><center><h3>Record inserted successfully...</h3></center><%
	}
	
	
	
	
	if(request.getParameter("del")!=null && session.getAttribute("editRow")!=null)
	{
		%><center><h3>Edit mode on...</h3></center><%
		System.out.println("Edit mode on");
		session.setAttribute("delRow", true);
		String s=request.getParameter("empno");
		session.setAttribute("DataToDel",s);
	}
	if(request.getParameter("save")!=null && session.getAttribute("delRow") != null)
	{
		session.removeAttribute("editRow");
		session.removeAttribute("delRow");
		String s=(String)session.getAttribute("DataToDel");
		int x=Integer.parseInt(s);
		query="delete from chinnu_crudd where empno="+x;
		PreparedStatement ps=conn.prepareStatement(query);
		ps.executeUpdate();
		System.out.println("record deleted successfully");
		%><center><h3>Record deleted successfully...</h3></center><%
	}
	
	
	
	

	
	if(request.getParameter("first")!=null)
	{
		session.setAttribute("counter",1);
		PreparedStatement f=conn.prepareStatement("select * from chinnu_crudd limit 1");
		ResultSet rs=f.executeQuery();
		while(rs.next())
		{
		System.out.println("first	"+rs.getString("empno"));
		%>
		<script>
		document.getElementById("eno").value ='<%=rs.getString("empno")%>';
		document.getElementById("ename").value ='<%=rs.getString("name")%>';
		document.getElementById("ejob").value ='<%= rs.getString("job")%>';
		document.getElementById("esal").value = '<%=rs.getString("salary")%>';
		document.getElementById("edept").value ='<%= rs.getString("department")%>';
		</script>
		<%
		}
	}
	
	
	int length=0;
	PreparedStatement leng=conn.prepareStatement("select count(*) from chinnu_crudd");
	ResultSet rsl=leng.executeQuery();
	if(rsl.next())
	{
		length=rsl.getInt(1);
	}
	if(request.getParameter("last")!=null)
	{
		session.setAttribute("counter",length);
		PreparedStatement l=conn.prepareStatement("select * from chinnu_crudd",ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rs=l.executeQuery();
		while(rs.next())
		{
			if(rs.last())
			{
				System.out.println("Last	"+rs.getString("empno"));
				%>
				<script>
				document.getElementById("eno").value ='<%=rs.getString("empno")%>';
				document.getElementById("ename").value ='<%=rs.getString("name")%>';
				document.getElementById("ejob").value ='<%= rs.getString("job")%>';
				document.getElementById("esal").value = '<%=rs.getString("salary")%>';
				document.getElementById("edept").value ='<%= rs.getString("department")%>';
				</script>
				<%
			}
		}
	}
	
	
	
	
	if(request.getParameter("prev")!=null)
	{
		int c=(int)session.getAttribute("counter");
		c--;
		if(c>=1)
		{
			session.setAttribute("counter",c);
			PreparedStatement f=conn.prepareStatement("select * from chinnu_crudd",ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ResultSet rs=f.executeQuery();
			if(rs.absolute(c))
			{
				System.out.println("prev	"+rs.getString("empno"));
				%>
				<script>
				document.getElementById("eno").value ='<%=rs.getString("empno")%>';
				document.getElementById("ename").value ='<%=rs.getString("name")%>';
				document.getElementById("ejob").value ='<%= rs.getString("job")%>';
				document.getElementById("esal").value = '<%=rs.getString("salary")%>';
				document.getElementById("edept").value ='<%= rs.getString("department")%>';
				</script>
				<%
			}
		}
	}
	
	
	
	
	
	if(request.getParameter("next")!=null)
	{
		int c=(int)session.getAttribute("counter");
		c++;
		if(c<=length)
		{
			session.setAttribute("counter",c);
			PreparedStatement f=conn.prepareStatement("select * from chinnu_crudd",ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ResultSet rs=f.executeQuery();
			if(rs.absolute(c))
			{
				System.out.println("prev	"+rs.getString("empno"));
				%>
				<script>
				document.getElementById("eno").value ='<%=rs.getString("empno")%>';
				document.getElementById("ename").value ='<%=rs.getString("name")%>';
				document.getElementById("ejob").value ='<%= rs.getString("job")%>';
				document.getElementById("esal").value = '<%=rs.getString("salary")%>';
				document.getElementById("edept").value ='<%= rs.getString("department")%>';
				</script>
				<%
			}
		}
	}
	
	
	
	
	if(request.getParameter("search")!=null)
	{
		int x=Integer.parseInt(request.getParameter("empno"));
		PreparedStatement f=conn.prepareStatement("select * from chinnu_crudd");
		ResultSet rs=f.executeQuery();
		while(rs.next())
		{
			if(x==Integer.parseInt(rs.getString("empno")))
			%>
			<script>
			document.getElementById("eno").value ='<%=rs.getString("empno")%>';
			document.getElementById("ename").value ='<%=rs.getString("name")%>';
			document.getElementById("ejob").value ='<%= rs.getString("job")%>';
			document.getElementById("esal").value = '<%=rs.getString("salary")%>';
			document.getElementById("edept").value ='<%= rs.getString("department")%>';
			</script>
			<%
			break;
		}
		
	}
	
	
	
}
catch(Exception e) { e.printStackTrace();}

 %>

<script>
function clearfun()
{
	document.getElementById("eno").value ="";
	document.getElementById("ename").value ="";
	document.getElementById("ejob").value = "";
	document.getElementById("esal").value = "";
	document.getElementById("edept").value = "";
}
function exitfun()
{
	window.close();
}
</script>
</body>
</html>
