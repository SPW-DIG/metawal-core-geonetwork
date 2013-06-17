//=============================================================================
//===	Copyright (C) 2001-2007 Food and Agriculture Organization of the
//===	United Nations (FAO-UN), United Nations World Food Programme (WFP)
//===	and United Nations Environment Programme (UNEP)
//===
//===	This program is free software; you can redistribute it and/or modify
//===	it under the terms of the GNU General Public License as published by
//===	the Free Software Foundation; either version 2 of the License, or (at
//===	your option) any later version.
//===
//===	This program is distributed in the hope that it will be useful, but
//===	WITHOUT ANY WARRANTY; without even the implied warranty of
//===	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//===	General Public License for more details.
//===
//===	You should have received a copy of the GNU General Public License
//===	along with this program; if not, write to the Free Software
//===	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
//===
//===	Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
//===	Rome - Italy. email: geonetwork@osgeo.org
//==============================================================================

package org.fao.geonet.services.metadata;

import jeeves.constants.Jeeves;
import jeeves.interfaces.Service;
import jeeves.resources.dbms.Dbms;
import jeeves.server.ServiceConfig;
import jeeves.server.context.ServiceContext;
import org.fao.geonet.GeonetContext;
import org.fao.geonet.constants.Geonet;
import org.fao.geonet.domain.Operation;
import org.fao.geonet.domain.OperationAllowed;
import org.fao.geonet.exceptions.MetadataNotFoundEx;
import org.fao.geonet.kernel.AccessManager;
import org.fao.geonet.kernel.DataManager;
import org.fao.geonet.kernel.MdInfo;
import org.fao.geonet.lib.Lib;
import org.fao.geonet.repository.OperationAllowedRepository;
import org.fao.geonet.repository.OperationRepository;
import org.fao.geonet.services.Utils;
import org.jdom.Element;

import java.util.List;
import java.util.Set;

//=============================================================================

/** Given a metadata id returns all operation allowed on it. Called by the
  * metadata.admin service
  */

public class GetAdminOper implements Service
{
	//--------------------------------------------------------------------------
	//---
	//--- Init
	//---
	//--------------------------------------------------------------------------

	public void init(String appPath, ServiceConfig params) throws Exception {}

	//--------------------------------------------------------------------------
	//---
	//--- Service
	//---
	//--------------------------------------------------------------------------

	public Element exec(Element params, ServiceContext context) throws Exception
	{
		GeonetContext gc = (GeonetContext) context.getHandlerContext(Geonet.CONTEXT_NAME);
		DataManager   dm = gc.getBean(DataManager.class);
		AccessManager am = gc.getBean(AccessManager.class);

		Dbms dbms = (Dbms) context.getResourceManager().open(Geonet.Res.MAIN_DB);

		String id = Utils.getIdentifierFromParameters(params, context);

		//-----------------------------------------------------------------------
		//--- check access

		MdInfo info = dm.getMetadataInfo(dbms, id);

		if (info == null)
			throw new MetadataNotFoundEx(id);

		Element ownerId = new Element("ownerid").setText(info.owner);
		Element groupOwner = new Element("groupOwner").setText(info.groupOwner);
		Element hasOwner = new Element("owner"); 
		if (am.isOwner(context,id)) 
			hasOwner.setText("true");
		else
			hasOwner.setText("false");

		//--- get all operations

        OperationRepository opRepository = context.getBean(OperationRepository.class);
        List<Operation> operationList = opRepository.findAll();


        // elOper is for returned XML and keeps backwards compatibility
        Element elOper = new Element(Geonet.Elem.OPERATIONS);

        for (Operation operation : operationList) {
            Element record = new Element("record")
                .addContent(new Element("id").setText(Integer.toString(operation.getId())))
                .addContent(new Element("name").setText(operation.getName()))
                .addContent(new Element("isreserved").setText(Boolean.toString(operation.isReserved())));
            elOper.addContent(record);
        }

        //-----------------------------------------------------------------------
		//--- retrieve groups operations

		Set<String> userGroups = am.getUserGroups(dbms, context.getUserSession(), context.getIpAddress(), false);

		Element elGroup = Lib.local.retrieve(dbms, "Groups");

        OperationAllowedRepository opAllowRepository = context.getBean(OperationAllowedRepository.class);

		@SuppressWarnings("unchecked")
        List<Element> list = elGroup.getChildren();
		for (Element el : list) {
			el.setName(Geonet.Elem.GROUP);
			String sGrpId = el.getChildText("id");
			int grpId = Integer.parseInt(sGrpId);

			//--- get all group informations (user member and user profile)
			
			el.setAttribute("userGroup", userGroups.contains(sGrpId) ? "true" : "false");
			
			String query = "SELECT profile FROM UserGroups WHERE userId=? AND groupId=?";
			Element profiles = dbms.select(query, context.getUserSession().getUserIdAsInt(), grpId);
			@SuppressWarnings("unchecked")
            List<Element> profilesList = profiles.getChildren();
			for (Element pEl : profilesList) {
				String profile = pEl.getChildText("profile");
				el.addContent(new Element("userProfile").setText(profile));
			}

            //--- get all operations that this group can do on given metadata
            List<OperationAllowed> opAllowList = opAllowRepository.findByGroupIdAndMetadataId(grpId, Integer.valueOf(id));

			for (Operation operation : operationList) {
				String operId = Integer.toString(operation.getId());

				Element elGrpOper = new Element(Geonet.Elem.OPER)
													.addContent(new Element(Geonet.Elem.ID).setText(operId));

				boolean bFound = false;

				for (OperationAllowed operationAllowed : opAllowList) {
					if (operation.getId() == operationAllowed.getId().getOperationId())
					{
						bFound = true;
						break;
					}
				}

				if (bFound)
					elGrpOper.addContent(new Element(Geonet.Elem.ON));

				el.addContent(elGrpOper);
			}
		}

		//-----------------------------------------------------------------------
		//--- put all together

		Element elRes = new Element(Jeeves.Elem.RESPONSE)
										.addContent(new Element(Geonet.Elem.ID).setText(id))
										.addContent(elOper)
										.addContent(elGroup)
										.addContent(ownerId)
										.addContent(hasOwner)
										.addContent(groupOwner);

		return elRes;
	}
}

//=============================================================================


