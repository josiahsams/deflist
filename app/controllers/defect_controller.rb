class DefectController < ApplicationController
def list
  @owner = params[:owner]
	input = params[:owner].split(",")
	@owner = input[0]
	@state = input[1]
       if (@state.nil?)
               @list_all=`rsh 9.3.144.105 -l josamuel "/gsa/ausgsa/projects/a/aix_tools/bin/cmvc/Report -family aix -view DefectView -where \\"ownerlogin in '#{@owner}' \\" -raw " | awk -F "|" '{print \$1,\$2, \$3,\$6, \$22,\$5, \$8,\$10,\$14, \$47, \$9, \$29}' `
        else
		@list_all=`rsh 9.3.144.105 -l josamuel "/gsa/ausgsa/projects/a/aix_tools/bin/cmvc/Report -family aix -view DefectView -where \\"ownerlogin in '#{@owner}' and state in '#{@state}'\\" -raw " | awk -F "|" '{print \$1,\$2, \$3,\$6, \$22,\$5, \$8,\$10,\$16, \$9, "<font color=red>", \$29, "</font>"}' `
                # @list_all=`rsh 9.3.144.105 -l josamuel "/gsa/ausgsa/projects/a/aix_tools/bin/cmvc/Report -family aix -view DefectView -where \\"ownerlogin in '#{@owner}' and state in '#{@state}'\\"" | tail +4 | grep -E "^a|^p" `
        end
	
end

def listTeam
	@list_all=`rsh 9.3.144.105 -l josamuel "cat /gsa/ausgsa/home/j/o/josamuel/defectOpenWorking" `
end

def report
	@month = params[:month]
	@year =  params[:year]
	time = Time.new
	if (@year.nil?)
		@year = time.year
	end
	if (@month.nil?)
		@month = time.strftime("%b")
	else
		case @month
			when "Jan","JAN","jan","january","January"
				@month="Jan"
				
			when "Feb","FEB","feb","february","February"
				@month="Feb"
				
			when "Mar","MAR","mar","march","March"
				@month="Mar"
				
			when "Apr","APR","apr","april","April"
				@month="Apr"
				
			when "May","MAY","may","May"
				@month="May"
				
			when "Jun","JUN","jun","june","June"
				@month="Jun"
				
			when "Jul","JUL","jul","july","July"
				@month="Jul"
				
			when "Aug","AUG","aug","august","August"
				@month="Aug"
				
			when "Sep","SEP","sep","september","September"
				@month="Sep"
				
			when "Oct","OCT","oct","october","October"
				@month="Oct"
				
			when "Nov","NOV","nov","november","November"
				@month="Nov"
				
			when "Dec","DEC","dec","december","December"
				@month="Dec"
				
			else
			    @month = time.strftime("%b")

		end
	end
	
	@incoming_list=`rsh 9.3.144.105 -l josamuel "cat /gsa/ausgsa/home/j/o/josamuel/reportscc/data/#{@month}_#{@year}_incoming_full" `
	@res_list=`rsh 9.3.144.105 -l josamuel "cat /gsa/ausgsa/home/j/o/josamuel/reportscc/data/#{@month}_#{@year}_res_full "`
end

def comp
        input = params[:comp].split(",")
        @comp = input[0]
        @state = input[1]
 if (@state.nil?)
	@list_all=`rsh 9.3.144.105 -l josamuel "/gsa/ausgsa/projects/a/aix_tools/bin/cmvc/Report -family aix -view DefectView -where \\"compname in '#{@comp}' \\" -raw " | awk -F "|" '{if (\$47 == "") \$47 = \"-\"; print \$1,\$2, \$3,\$6, \$22,\$5, \$8,\$10,\$14, \$47, \$39, \$9, \$29}'`
  else
	@list_all=`rsh 9.3.144.105 -l josamuel "/gsa/ausgsa/projects/a/aix_tools/bin/cmvc/Report -family aix -view DefectView -where \\"compname in '#{@comp}'  and state in '#{@state}'\\" -raw " | awk -F "|" '{if (\$47 == "") \$47 = \"-\"; print \$1,\$2, \$3,\$6, \$22,\$5, \$8,\$10,\$14, \$47, \$39, \$9, \$29}'`

  end

end

def csv
	require 'fastercsv'
        input = params[:comp].split(",")
        @comp = input[0]
        @state = input[1]
 if (@state.nil?)
	@list_all=`rsh 9.3.144.105 -l josamuel "/gsa/ausgsa/projects/a/aix_tools/bin/cmvc/Report -family aix -view DefectView -where \\"compname in '#{@comp}' \\" -raw " | awk -F "|" '{if (\$47 == "") \$47 = \"-\"; print \$1,\$2, \$3,\$6, \$22,\$5, \$8,\$10,\$14, \$47, \$39, \$9, \$29}'`
  else
	@list_all=`rsh 9.3.144.105 -l josamuel "/gsa/ausgsa/projects/a/aix_tools/bin/cmvc/Report -family aix -view DefectView -where \\"compname in '#{@comp}'  and state in '#{@state}'\\" -raw " | awk -F "|" '{if (\$47 == "") \$47 = \"-\"; print \$1,\$2, \$3,\$6, \$22,\$5, \$8,\$10,\$14, \$47, \$39, \$9, \$29}'`


csv_string = FasterCSV.generate do |csv| 
            csv << ["Prefix","Defect","Component","State","Owner","Sev","Age","Update","CQID", "phase", "Abstract"  ]

	@list_all.each do |list|
		fields = list.split
		cur = 12
		abstract=""
		while cur < fields.size do
			abstract += fields[cur] + " "
			cur += 1
		end

              csv << [fields[0], fields[1], fields[2], fields[3], fields[5], fields[6], fields[7], fields[8], fields[10], fields[11], abstract ]

	end


end
          send_data csv_string, :type => "text/plain", 
           :filename=>"defect--#{Time.now.strftime('%Y%m%d')}.csv",
           :disposition => 'attachment'


  end
end


def list1
	@owner = params[:owner]
        input = params[:owner].split(",")
        @owner = input[0]
        @state = input[1]
        if (@state.nil?)
                @list_all=`rsh 9.3.144.105 -l josamuel "/gsa/ausgsa/projects/a/aix_tools/bin/cmvc/Report -family aix -view DefectView -where \\"originlogin in '#{@owner}' \\"" | tail +4 | grep -E "^a|^p" `
        else
                @list_all=`rsh 9.3.144.105 -l josamuel "/gsa/ausgsa/projects/a/aix_tools/bin/cmvc/Report -family aix -view DefectView -where \\"originlogin in '#{@owner}' and state in '#{@state}'\\"" | tail +4 | grep -E "^a|^p" `
	end
end

def feature
        @owner = params[:owner]
        input = params[:owner].split(",")
        @owner = input[0]
        @state = input[1]
        if (@state.nil?)
                @list_all=`rsh 9.3.144.105 -l josamuel "/gsa/ausgsa/projects/a/aix_tools/bin/cmvc/Report -family aix -view FeatureView -where \\"ownerlogin in '#{@owner}' \\"" | tail +4 | grep -E "^d" `
        else
                @list_all=`rsh 9.3.144.105 -l josamuel "/gsa/ausgsa/projects/a/aix_tools/bin/cmvc/Report -family aix -view FeatureView -where \\"ownerlogin in '#{@owner}' and state in '#{@state}'\\"" | tail +4 | grep -E "^d" `
	end
	end

def admin
        @owner = params[:owner]
        input = params[:owner].split(",")
        @owner = input[0]
        @state = input[1]
        if (@state.nil?)
                @list_all=`rsh 9.3.144.105 -l josamuel "/gsa/ausgsa/projects/a/aix_tools/bin/cmvc/Report -family admin -view DefectView -where \\"originlogin in '#{@owner}' \\"" | tail +4 | grep -E "^a|^p" `
        else
                @list_all=`rsh 9.3.144.105 -l josamuel "/gsa/ausgsa/projects/a/aix_tools/bin/cmvc/Report -family admin -view DefectView -where \\"originlogin in '#{@owner}' and state in '#{@state}'\\"" | tail +4 | grep -E "^a|^p" `
        end
end

def cq

	@list_all=`/home/josiah_sams\@in.ibm.com/CQ/cqcmd.pl  -action query -fields 'saved::Public Queries/Active Defects I Own' `
end

def adminlist
  @owner = params[:owner]
        input = params[:owner].split(",")
        @owner = input[0]
        @state = input[1]
       if (@state.nil?)
               @list_all=`rsh 9.3.144.105 -l josamuel "/gsa/ausgsa/projects/a/aix_tools/bin/cmvc/Report -family admin -view DefectView -where \\"ownerlogin in '#{@owner}' \\" -raw " | awk -F "|" '{print \$1,\$2, \$3,\$6, \$22,\$5, \$8,\$10,\$16, \$9, "<font color=red>", \$29, "</font>"}' `
        else
                @list_all=`rsh 9.3.144.105 -l josamuel "/gsa/ausgsa/projects/a/aix_tools/bin/cmvc/Report -family admin -view DefectView -where \\"ownerlogin in '#{@owner}' and state in '#{@state}'\\" -raw " | awk -F "|" '{print \$1,\$2, \$3,\$6, \$22,\$5, \$8,\$10,\$16, \$9, "<font color=red>", \$29, "</font>"}' `
	end
end

end
